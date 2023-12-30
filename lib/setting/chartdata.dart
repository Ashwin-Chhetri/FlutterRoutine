import 'package:intl/intl.dart';

class ChartData {
  static Map<DateTime, int> getHeatMapData(Map<String, Map<String, dynamic>> routineHistory) {
    if (routineHistory.isEmpty) {
      return {};
    }
    final formatter = DateFormat('dd/MM/yyyy');
    Map<DateTime, int> heatMap = {};
    routineHistory.forEach((key, value) {
      DateTime dateTime = formatter.parse(key);
      heatMap[dateTime] = value.length >= 10 ? 10 : value.length; // Max Value is 10
    });

    return heatMap;
  }

  static void getBarChartData() {}
}
