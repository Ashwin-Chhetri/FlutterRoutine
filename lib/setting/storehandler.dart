import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:minaroutine/setting/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Helper class for managing the routine

class StoreHandler {
  static SharedPreferences? _preferences;

  //Get the Shared Preferences instance
  static Future<SharedPreferences> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // check if the Key is present
  static Future<bool> checkIfStringExists(String key) async {
    final prefs = await StoreHandler.instance;
    return prefs.containsKey(key);
  }

  // Get the Routine
  static Future<Map<String, Map>> getRoutine() async {
    final prefs = await StoreHandler.instance;
    String jsonString = prefs.getString(Constants.MYROUTINE) ?? '{}';
    // convert Json into Map
    Map<String, Map> myRoutine = Map<String, Map>.from(json.decode(jsonString));
    return myRoutine;
  }

  // Encode and Store the Routine
  //{start_time:{end_time:{start_time:value,end_time:value,routineName:value,objective:value}}}
  static void storeRoutine(Map<String, Map> newRoutine) async {
    final prefs = await StoreHandler.instance;
    //Check if the Routine exist already
    if (await checkIfStringExists(Constants.MYROUTINE)) {
      //get the existing Routine
      Map<String, Map> myRoutines = await getRoutine();
      //Add the routine
      if (myRoutines.keys.toList().contains(newRoutine.keys.toList()[0])) {
        sortRoutine(myRoutines, newRoutine);
      } else {
        myRoutines.addAll(newRoutine);
      }
      newRoutine = myRoutines;
    }
    String routineJson = json.encode(newRoutine);
    await prefs.setString(Constants.MYROUTINE, routineJson);
  }

  //Delete routine
  static Future<bool> deleteRoutine() async {
    final prefs = await StoreHandler.instance;
    //Check if the Routine exist already
    if (await checkIfStringExists(Constants.MYROUTINE)) {
      return await prefs.remove(Constants.MYROUTINE);
    }
    return true;
  }

  static Map<String, Map> sortRoutine(Map<String, Map> myRoutines, Map<String, Map> newRoutine) {
    if (myRoutines.isEmpty) {
      //Combine the Routine
      myRoutines.addAll(newRoutine);
      return myRoutines;
    } else {
      //Sort by StartTime and endTime
      String newStartTimeKey = newRoutine.keys.toList()[0];
      if (myRoutines.keys.toList().contains(newStartTimeKey)) {
        //sort the endTime Keys

        final myRoutineEndTime =
            DateFormat('h:mm a').parse(myRoutines[newStartTimeKey]!.keys.toList()[0]);
        final newRoutineEndTime =
            DateFormat('h:mm a').parse(newRoutine[newStartTimeKey]!.keys.toList()[0]);

        if (myRoutineEndTime.isBefore(newRoutineEndTime)) {
          myRoutines[newStartTimeKey]!.addAll(newRoutine[newStartTimeKey]!);
        } else {
          var temp = myRoutines[newStartTimeKey]!;
          myRoutines[newStartTimeKey] = {};

          myRoutines[newStartTimeKey]!
            ..addAll(newRoutine[newStartTimeKey]!)
            ..addAll(temp);
        }
      } else {
        myRoutines.addAll(newRoutine);
      }
      return myRoutines;
    }
  }

  // Get the Routine Progress
  static Future<Map<String, bool>> getRoutineProgress() async {
    final prefs = await StoreHandler.instance;
    Map<String, bool> currentRoutine = {};
    if (await checkIfStringExists(Constants.MYROUTINEPROGRESS)) {
      final String currentDay = DateFormat('dd/MM/yyyy').format(DateTime.now());
      String jsonString = prefs.getString(Constants.MYROUTINEPROGRESS)!;
      Map<String, Map<String, dynamic>> resultProgress =
          Map<String, Map<String, dynamic>>.from(json.decode(jsonString));
      //Type cast the dynamic to bool type
      Map<String, Map<String, bool>> myRoutineProgress =
          resultProgress.map((key, value) => MapEntry(key, value.cast<String, bool>()));
      if (myRoutineProgress.keys.toList().contains(currentDay)) {
        currentRoutine = myRoutineProgress[currentDay]!;
      }
    }
    return currentRoutine;
  }

  //store the daily routine progress
  static void storeProgress(Map<String, bool> newRoutine) async {
    final prefs = await StoreHandler.instance;
    //get current time and add the routine
    final String currentDay = DateFormat('dd/MM/yyyy').format(DateTime.now());
    //Check if the Routine exist already
    String routineJson = json.encode({currentDay: newRoutine});

    await prefs.setString(Constants.MYROUTINEPROGRESS, routineJson);
  }

  static Future<Map<DateTime, int>> getHistory() async {
    final formatter = DateFormat('dd/MM/yyyy');
    final prefs = await StoreHandler.instance;
    Map<DateTime, int> heatMap = {};
    if (await checkIfStringExists(Constants.MYROUTINEPROGRESS)) {
      String jsonString = prefs.getString(Constants.MYROUTINEPROGRESS)!;
      Map<String, Map<String, dynamic>> progressHistory =
          Map<String, Map<String, dynamic>>.from(json.decode(jsonString));
      progressHistory.forEach((key, value) {
        DateTime dateTime = formatter.parse(key);
        heatMap[dateTime] = value.length >= 10 ? 10 : value.length;
      });
    }

    return heatMap;
  }
}
