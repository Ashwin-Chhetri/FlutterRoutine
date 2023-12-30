import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:minaroutine/model/routineHistory.dart';
import 'package:minaroutine/setting/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RoutineHistoryData {
  static String routineHistoryPrefKey = Constants.MYROUTINEPROGRESS;
  static SharedPreferences? _preferences;

  //Get the Shared Preferences instance
  static Future<SharedPreferences> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // check if the String is present in SharedPreference
  static Future<bool> checkIfStringExists(String key) async {
    final prefs = await RoutineHistoryData.instance;
    return prefs.containsKey(key);
  }

  // Get the Routine Progress of current day
  static Future<Map<String, dynamic>> getCurrentDayProgressHistory() async {
    final prefs = await RoutineHistoryData.instance;
    Map<String, dynamic> currentRoutineHistory = {};
    if (await checkIfStringExists(Constants.MYROUTINEPROGRESS)) {
      String jsonString = prefs.getString(Constants.MYROUTINEPROGRESS) ?? '{}';

      currentRoutineHistory = await parseRoutineHistory(jsonString).getCurrentDayHistory;
    }
    return currentRoutineHistory;
  }

  //store the daily routine progress
  static void storeProgress(Map<String, dynamic> newRoutine) async {
    final prefs = await RoutineHistoryData.instance;
    //get current time and add the routine
    final String currentDay = DateFormat('dd/MM/yyyy').format(DateTime.now());
    //Check if the Routine exist already
    String routineJson = json.encode({currentDay: newRoutine});
    //print("Print stroring the new Progress $routineJson");

    await prefs.setString(Constants.MYROUTINEPROGRESS, routineJson);
  }

  static Future<Map<String, Map<String, dynamic>>> getHistory() async {
    final prefs = await RoutineHistoryData.instance;
    Map<String, Map<String, dynamic>> routineHistory = {};

    if (await checkIfStringExists(Constants.MYROUTINEPROGRESS)) {
      String jsonString = prefs.getString(Constants.MYROUTINEPROGRESS) ?? '{}';

      routineHistory = Map<String, Map<String, dynamic>>.from(json.decode(jsonString));
    }
    return routineHistory;
  }

  //parse routine from json to map
  static RoutineHistory parseRoutineHistory(String routineHistoryJson) {
    return RoutineHistory(
        routineHistory: Map<String, Map<String, dynamic>>.from(json.decode(routineHistoryJson)));
  }
}
