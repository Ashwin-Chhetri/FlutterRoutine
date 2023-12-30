import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:minaroutine/setting/apptheme.dart';

class MyHeatMap extends StatefulWidget {
  const MyHeatMap({super.key, required this.routineHistortHeatMap});
  final Map<DateTime, int> routineHistortHeatMap;

  @override
  State<MyHeatMap> createState() => _MyHeatMapState();
}

class _MyHeatMapState extends State<MyHeatMap> {
  bool isOpacityMode = true;
  DateTime now = DateTime.now();
  late DateTime currentMonthStartDate;
  late DateTime currentMonthEndDate;
  @override
  void initState() {
    currentMonthStartDate = DateTime(now.year, now.month, 1);
    currentMonthEndDate = DateTime(now.year, now.month + 1, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: HeatMapCalendar(
          datasets: widget.routineHistortHeatMap,
          initDate: currentMonthStartDate,
          colorMode: ColorMode.opacity,
          size: 30,
          textColor: AppTheme.lightPrimary,
          fontSize: 14,
          monthFontSize: 17,
          weekFontSize: 13,
          weekTextColor: AppTheme.lightSecondary,
          colorsets: const {
            0: Color(0xFFCCE7CD),
            1: Color(0xFFB1E1B1),
            2: Color(0xFF8FD98E),
            3: Color(0xFF70D670),
            4: Color(0xFF4FD550),
            5: Color(0xFF29D32A),
            6: Color(0xFF18C219),
            7: Color(0xFF0FAA0E),
            8: Color(0xFF15A414),
            9: Color(0xFF0A8B0C),
            10: Color(0xFF267025),
          },
          onClick: (value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
          },
        ),
      ),
    );
  }
}
