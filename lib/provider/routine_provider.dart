import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minaroutine/data/routinehistorydata.dart';
import 'package:minaroutine/data/routinedata.dart';
import 'package:minaroutine/model/routine.dart';
import 'package:minaroutine/setting/chartdata.dart';

class RoutineProvider extends ChangeNotifier {
  final DateFormat formatter = DateFormat('h:mm a');
  //routine variables
  Routine _routine = Routine(routine: {});
  int _highlightRoutine = 0;
  //day progress variables
  late Map<String, dynamic> _dayRoutineProgress = {};
  late double _progressValue = 0.0;
  // routine history variables
  late Map<DateTime, int> _routineHistortHeatMap = {};

  Routine get routine => _routine;
  Map<String, dynamic> get dayRoutineProgress => _dayRoutineProgress;
  Map<DateTime, int> get routineHistortHeatMap => _routineHistortHeatMap;
  // ignore: unnecessary_getters_setters
  int get highlightRoutine => _highlightRoutine;
  double get progressValue => _progressValue;

  ///Setter
  set highlightRoutine(int routineIndex) {
    _highlightRoutine = routineIndex;
  }

  //Get routine
  Future<void> getRoutine() async {
    _routine = await RoutineData.getRoutine();
    notifyListeners();
  }

  //Store Routine
  void storeRoutine(Routine newRoutine) {
    addNewRoutineToOldRoutine(newRoutine, routine);
    RoutineData.storeRoutine(_routine);
    udpateProgress();
    notifyListeners();
  }

  //Delete routine
  void deleteRoutine() async {
    RoutineData.deleteRoutine();
    _routine = await RoutineData.getRoutine();
    notifyListeners();
  }

  //Get dayRoutineProgress if empty
  Future<void> getCurrentDayRoutineProgress() async {
    _dayRoutineProgress = await RoutineHistoryData.getCurrentDayProgressHistory();
    udpateProgress();
    notifyListeners();
  }

  void getRoutineHistory() async {
    Map<String, Map<String, dynamic>> routineHistory;
    //returns the history of the Routine:
    routineHistory = await RoutineHistoryData.getHistory();
    _routineHistortHeatMap = ChartData.getHeatMapData(routineHistory);

    notifyListeners();
  }

  void setRoutineProgress(String routineProgressIndex, bool value) {
    _dayRoutineProgress[routineProgressIndex] = value;
    udpateProgress();

    //store
    RoutineHistoryData.storeProgress(dayRoutineProgress);
    notifyListeners();
  }

  // //convert hour from hh:mm a into h:mm a format
  String typeCastHour(String time) {
    return DateFormat('h:mm a').format(DateFormat('hh:mm a').parse(time)).toLowerCase();
  }

  void udpateProgress() {
    // Check if the Routine is not empty
    if (routine.getRoutineMap.isNotEmpty) {
      int dayprogress = 0;
      for (var outer in routine.getRoutineMap.entries) {
        String startTimeStr = outer.key;
        for (var inner in routine.getRoutineMap[startTimeStr]!.entries) {
          String endTimeStr = inner.key;
          String routineName = routine.getRoutineMap[startTimeStr]![endTimeStr]['RoutineName'];
          String currentRoutineIndex = '${startTimeStr}_${endTimeStr}_$routineName';
          //Check if the Key is present
          if (_dayRoutineProgress.containsKey(currentRoutineIndex)) {
            if (_dayRoutineProgress[currentRoutineIndex]) {
              dayprogress++;
            }
          }
        }
      }
      _progressValue = (dayprogress / _routine.getRoutineMap.length);
      // print(
      //     "Print Called updateProgress $_progressValue $dayprogress ${_routine.getRoutineMap.length}");
    }
  }

  void addNewRoutineToOldRoutine(Routine newRoutine, Routine oldRoutine) {
    //check the first and last dateTime with newRoutine Time
    if (oldRoutine.getRoutineMap.isEmpty) {
      _routine = newRoutine;
      return;
    }
    DateTime newRoutineStartTime = newRoutine.getStartTimeAsDateTime[0];
    List<DateTime> oldRoutineStartTime = oldRoutine.getStartTimeAsDateTime;
    DateTime oldRoutineFirstStartTime = oldRoutineStartTime.first;
    DateTime oldRoutineLastStartTime = oldRoutineStartTime.last;

    if ((newRoutineStartTime.isAtSameMomentAs(oldRoutineFirstStartTime)) ||
        (newRoutineStartTime.isBefore(oldRoutineFirstStartTime))) {
      //add new Routine first
      _routine = Routine(routine: {...newRoutine.getRoutineMap, ...routine.getRoutineMap});
      return;
    }
    if ((newRoutineStartTime.isAtSameMomentAs(oldRoutineLastStartTime)) ||
        (newRoutineStartTime.isAfter(oldRoutineLastStartTime))) {
      // add new Routine last
      _routine = Routine(routine: {
        ...routine.getRoutineMap,
        ...newRoutine.getRoutineMap,
      });
      return;
    }

    //remove the first and the last start time key
    if (oldRoutineStartTime.isNotEmpty) {
      oldRoutineStartTime.remove(oldRoutineStartTime.first);
    }
    if (oldRoutineStartTime.isNotEmpty) {
      oldRoutineStartTime.remove(oldRoutineStartTime.last);
    }
    Map<String, Map<String, dynamic>> result = {};
    for (DateTime oldRoutineStartTimekey in oldRoutineStartTime) {
      if (newRoutineStartTime.isAfter(oldRoutineStartTimekey)) {
        if (oldRoutine.getRoutineMap[oldRoutineStartTimekey] != null) {
          result.addAll({
            formatter.format(oldRoutineStartTimekey):
                oldRoutine.getRoutineMap[oldRoutineStartTimekey] ?? {},
            ...newRoutine.getRoutineMap
          });
        } else {
          result.addAll({
            formatter.format(oldRoutineStartTimekey):
                oldRoutine.getRoutineMap[oldRoutineStartTimekey] ?? {},
            ...newRoutine.getRoutineMap
          });
        }
      } else {
        if (oldRoutine.getRoutineMap[oldRoutineStartTimekey] != null) {
          result.addAll({
            formatter.format(oldRoutineStartTimekey):
                oldRoutine.getRoutineMap[oldRoutineStartTimekey]!
          });
        }
      }
    }
    _routine = Routine(routine: result);
    return;
  }
}
