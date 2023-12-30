// class RoutineHistory {
//   final String startDate;
//   final String routineWithTime; // startDate_endDate_RoutineName
//   final bool hasCompleted;

//   const RoutineHistory(
//       {required this.startDate, required this.routineWithTime, required this.hasCompleted});

//   String get getStartTime => startDate;
//   String get getRoutineWithTime => routineWithTime;
//   bool get getHasCompleted => hasCompleted;

//   Map<String, Map> get getMap => {
//         startDate: {routineWithTime: getHasCompleted}
//       };
// }

import 'package:intl/intl.dart';
import 'package:minaroutine/data/routinedata.dart';
import 'package:minaroutine/model/routine.dart';

class RoutineHistory {
  final String currentDay = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final Map<String, Map<String, dynamic>> routineHistory;

  RoutineHistory({required this.routineHistory});

  Map<String, Map<String, dynamic>> get getRoutineHistory => routineHistory;

  Future<Map<String, dynamic>> get getCurrentDayHistory async {
    if (routineHistory.isNotEmpty && routineHistory.containsKey(currentDay)) {
      return routineHistory[currentDay]!;
    } else {
      // create a new Routine Progress for the currect day if  not present
      Routine routine = await RoutineData.getRoutine();
      return routineHistory[currentDay] = routine.getRoutineKeyForHistory();
    }
  }

  // Add new routine history
  RoutineHistory addRoutine(RoutineHistory newRoutineDay) {
    Map<String, Map<String, dynamic>> addedRoutineHistory = {
      ...routineHistory,
      ...newRoutineDay.getRoutineHistory
    };
    return RoutineHistory(routineHistory: addedRoutineHistory);
  }
}
