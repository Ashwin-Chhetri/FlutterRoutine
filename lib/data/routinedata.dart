import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:minaroutine/model/routine.dart';
import 'package:minaroutine/setting/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Deals with CRUD operation on Routine Data
class RoutineData {
  static String routinePrefKey = Constants.MYROUTINE;
  static SharedPreferences? _preferences;

  //Get the Shared Preferences instance
  static Future<SharedPreferences> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  //check if the String is present in SharedPreference
  static Future<bool> checkIfStringExists(String key) async {
    final prefs = await RoutineData.instance;
    return prefs.containsKey(key);
  }

  //get
  static Future<Routine> getRoutine() async {
    final prefs = await RoutineData.instance;
    String jsonString = prefs.getString(routinePrefKey) ?? '{}';
    // convert Json into Map
    Routine myRoutine = parseRoutine(jsonString);
    return myRoutine;
  }

  //Encode and Store the Routine
  //{start_time:{end_time:{start_time:value,end_time:value,routineName:value,objective:value}}}
  static void storeRoutine(Routine newRoutine) async {
    final prefs = await RoutineData.instance;
    String routineJson = json.encode(newRoutine.getRoutineMap);
    await prefs.setString(Constants.MYROUTINE, routineJson);
  }

  static Routine sortRoutine(Routine myRoutines, Routine newRoutine) {
    if (myRoutines.getRoutineMap.isEmpty) {
      //Combine the Routine
      myRoutines.addRoutine(newRoutine);
      return myRoutines;
    } else {
      //Sort by StartTime and endTime
      String newStartTimeKey = newRoutine.getStartTimeAsString[0];
      if (myRoutines.getStartTimeAsString.contains(newStartTimeKey)) {
        //sort the endTime Keys
        if (isStartTimeBeforeEndTime(
            myRoutines.getStartTimeAsString[0], newRoutine.getStartTimeAsString[0])) {
          myRoutines.getRoutineMap[newStartTimeKey] = {
            ...myRoutines.getRoutineMap[newStartTimeKey]!,
            ...newRoutine.getRoutineMap[newStartTimeKey]!
          };
        } else {
          myRoutines.getRoutineMap[newStartTimeKey] = {
            ...newRoutine.getRoutineMap[newStartTimeKey]!,
            ...myRoutines.getRoutineMap[newStartTimeKey]!
          };
        }
      } else {
        myRoutines.addRoutine(newRoutine);
      }
      return myRoutines;
    }
  }

  //Delete routine
  static Future<bool> deleteRoutine() async {
    final prefs = await RoutineData.instance;
    //Check if the Routine exist already
    if (await checkIfStringExists(Constants.MYROUTINE)) {
      return await prefs.remove(Constants.MYROUTINE);
    }
    return true;
  }

  //parse routine from json to map
  static Routine parseRoutine(String routineJson) {
    return Routine(routine: Map<String, Map<String, dynamic>>.from(json.decode(routineJson)));
  }

  /// Returns True if the first Time
  static bool isStartTimeBeforeEndTime(String startTime, String endTime) {
    if (startTime.isEmpty && endTime.isEmpty) {
      return false;
    }
    DateFormat formatter = DateFormat('h:mm a');
    DateTime startDateTime = formatter.parse(startTime);
    DateTime endDateTime = formatter.parse(endTime);
    return startDateTime.isBefore(endDateTime);
  }

  static bool isTimeContainsNow(String startTimeStr, String endTimeStr) {
    DateFormat formatter = DateFormat('hh:mm a');
    String currentHourStr = formatter.format(DateTime.now());
    DateTime startTime = formatter.parse(startTimeStr);
    DateTime endTime = formatter.parse(endTimeStr);
    DateTime currentTime = formatter.parse(currentHourStr);

    if ((currentTime.isAtSameMomentAs(startTime) || currentTime.isAfter(startTime)) &&
        (currentTime.isAtSameMomentAs(endTime) || currentTime.isBefore(endTime))) {
      return true;
    } else {
      return false;
    }
  }
}
