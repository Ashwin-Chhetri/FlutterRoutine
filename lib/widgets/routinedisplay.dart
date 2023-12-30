import 'package:flutter/material.dart';
import 'package:minaroutine/provider/routine_provider.dart';
import 'package:minaroutine/setting/apptheme.dart';
import 'package:provider/provider.dart';

class RoutineDisplay extends StatefulWidget {
  final bool highlight;
  final String startTimeStr;
  final String endTimeStr;
  final String routineName;
  const RoutineDisplay({
    super.key,
    required this.highlight,
    required this.startTimeStr,
    required this.endTimeStr,
    required this.routineName,
  });

  @override
  State<RoutineDisplay> createState() => _RoutineDisplayState();
}

class _RoutineDisplayState extends State<RoutineDisplay> {
  late RoutineProvider routineProvider;
  //late bool _checkboxStatus;
  late TextStyle timetextStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12);
  late TextStyle headingTextStyle = const TextStyle(
      color: AppTheme.lightSecondary,
      fontWeight: FontWeight.w300,
      letterSpacing: 2.0,
      fontSize: 14);
  late double roundedWidth, roundedHeight;

  @override
  void initState() {
    super.initState();
  }

  bool checkRoutineProgress(String key) {
    if (routineProvider.dayRoutineProgress.containsKey(key)) {
      return routineProvider.dayRoutineProgress[key]! as bool;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    //Get the routine
    routineProvider = Provider.of<RoutineProvider>(context);

    roundedWidth = widget.highlight ? 10 : 8;
    roundedHeight = widget.highlight ? 10 : 8;
    if (widget.highlight) {
      timetextStyle = timetextStyle.copyWith(fontSize: 14);
      headingTextStyle = headingTextStyle.copyWith(fontSize: 17);
    }
    // if (widget.highlight) {
    //   routineProvider.highlightRoutine = widget.startTimeStr;
    // }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Container(
                    width: roundedWidth,
                    height: roundedHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white60, width: 1.5),
                    ),
                  ),
                  const Expanded(
                    child: VerticalDivider(
                      color: Colors.white60,
                      thickness: 1.5,
                    ),
                  ),
                  Container(
                    width: roundedWidth,
                    height: roundedHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white60, width: 1.5),
                    ),
                  )
                ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      routineProvider.typeCastHour(widget.startTimeStr),
                      style: timetextStyle,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      routineProvider.typeCastHour(widget.endTimeStr),
                      style: timetextStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              height: 60,
              alignment: Alignment.center,
              child: Text(
                widget.routineName,
                style: headingTextStyle,
              ),
            )),
        Flexible(
          flex: 1,
          child: Checkbox(
            value: checkRoutineProgress(
                '${widget.startTimeStr}_${widget.endTimeStr}_${widget.routineName}'),
            onChanged: (value) {
              // //{"06:00 AM_07:00_RoutineName": true}
              String currentRoutineIndex =
                  '${widget.startTimeStr}_${widget.endTimeStr}_${widget.routineName}';

              routineProvider.setRoutineProgress(currentRoutineIndex, value!);
            },
          ),
        )
      ],
    );
  }
}
