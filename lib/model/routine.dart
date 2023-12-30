import 'package:intl/intl.dart';

// class Routine {
//   final String startTime;
//   final String endTime;
//   final String routineName;
//   final String objective;

//   const Routine({
//     required this.startTime,
//     required this.endTime,
//     required this.routineName,
//     required this.objective,
//   });

//   String get getStartTime => startTime;
//   String get getEndTime => endTime;
//   String get getRoutineName => routineName;
//   String get getObjective => objective;

//   Map<String, Map> get getRoutine => {
//         startTime: {
//           endTime: {
//             'startTime': startTime,
//             'endTime': endTime,
//             'RoutineName': routineName,
//             'Objective': objective
//           }
//         }
//       };
// }

class Routine {
  final formatter = DateFormat('h:mm a');
  final Map<String, Map<String, dynamic>> routine;

  Routine({required this.routine});

  Map<String, Map<String, dynamic>> get getRoutineMap => routine;

  // get start time key
  List<String> get getStartTimeAsString => routine.keys.toList();
  List<DateTime> get getStartTimeAsDateTime =>
      routine.keys.map((startTime) => formatter.parse(startTime)).toList();
  // get end time key
  List<String> getEndTimeAsString(String startTimeKey) {
    if (!routine.keys.toList().contains(startTimeKey)) {
      return [];
    }
    return routine[startTimeKey]!.keys.toList();
  }

  //return  startTime_endTime_RoutineName key and set defaully value as false
  Map<String, bool> getRoutineKeyForHistory() {
    Map<String, bool> newRoutineProgress = {};
    for (String startTime in routine.keys) {
      for (String endTime in routine[startTime]!.keys) {
        newRoutineProgress[
            '${startTime}_${endTime}_${routine[startTime]![endTime]['RoutineName']}'] = false;
      }
    }
    return newRoutineProgress;
  }

  //get Routine Name
  String getRoutineName(String startTimeKey, String endTimeKey) {
    if (!routine.keys.toList().contains(startTimeKey)) {
      return '';
    }
    if (!routine[startTimeKey]!.keys.toList().contains(endTimeKey)) {
      return '';
    }
    return routine[startTimeKey]![endTimeKey]['RoutineName'];
  }

  Routine addRoutine(Routine newRoutine) {
    Map<String, Map<String, dynamic>> addedRoutine = {...routine, ...newRoutine.getRoutineMap};
    return Routine(routine: addedRoutine);
  }
}
