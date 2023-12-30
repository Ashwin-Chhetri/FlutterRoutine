import 'package:flutter/material.dart';
import 'package:minaroutine/data/routinedata.dart';
import 'package:minaroutine/provider/routine_provider.dart';
import 'package:minaroutine/setting/setting.dart';
import 'package:minaroutine/widgets/routinedisplay.dart';
import 'package:provider/provider.dart';

class RoutineView extends StatefulWidget {
  const RoutineView({super.key});

  @override
  State<RoutineView> createState() => _DisplayRoutineState();
}

class _DisplayRoutineState extends State<RoutineView> {
  final ScrollController _scrollController = ScrollController();
  late RoutineProvider routineProvider;
  late int highlightIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      jumpUIToCurrentRoutine(); // Need to fix
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void jumpUIToCurrentRoutine() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(80.0 * routineProvider.highlightRoutine);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get the routine
    routineProvider = Provider.of<RoutineProvider>(context);

    return Center(
        child: SizedBox(
      height: 400,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: routineProvider.routine.getRoutineMap.length,
        itemBuilder: (context, index) {
          String startTimeStr = routineProvider.routine.getStartTimeAsString[index];
          String endTimeStr = routineProvider.routine.getEndTimeAsString(startTimeStr)[0];
          String routineName = routineProvider.routine.getRoutineName(startTimeStr, endTimeStr);

          bool highlight = RoutineData.isTimeContainsNow(startTimeStr, endTimeStr);
          if (highlight) routineProvider.highlightRoutine = index;

          return Wrap(alignment: WrapAlignment.center, children: [
            Opacity(
              opacity: highlight ? 1.0 : 0.7,
              child: Container(
                  width: highlight ? 400 : 330,
                  height: highlight ? 70 : 60,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: highlight ? AppTheme.lightPrimary : Colors.grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        //light shadow top-left
                        BoxShadow(offset: Offset(-5, -5), blurRadius: 5, color: Colors.white30),
                        //dark shadow bottom-right
                        BoxShadow(offset: Offset(5, 5), blurRadius: 5, color: Colors.black38)
                      ]),
                  //startTime endTime RoutineName

                  child: RoutineDisplay(
                    highlight: highlight,
                    startTimeStr: startTimeStr,
                    endTimeStr: endTimeStr,
                    routineName: routineName,
                  )),
            )
          ]);
        },
      ),
    ));
  }
}
