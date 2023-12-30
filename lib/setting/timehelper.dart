import 'package:intl/intl.dart';

class DateTimeHelper {
  ///Convert 'h:mm a' into  the 12-Hr DateTime format
  ///starts from 12:00 AM(midnight) and ends at 11:59 PM(noon)
  static String convert12Hour(String time) {
    try {
      int hour = int.parse(time.split(':')[0]);
      int minute = int.parse(time.split(':')[1].split(' ')[0]);
      String period = time.split(':')[1].split(' ')[1];
      //validate the String
      if (hour < 1 ||
          hour > 12 ||
          minute < 0 ||
          minute > 59 ||
          (period != 'AM' && period != 'PM')) {
        throw const FormatException('Invalid input format');
      }
      if (hour > 12) {
        hour = hour - 12;
        period = 'PM';
      }

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return 'Enter Time';
    }
  }

  /// Convert h:mm a format into DateTime
  /// Note: Within DateTime the hours are represented as 24Hr(00:24)
  static DateTime convertDateTime(String time) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateFormat('h:mm a').parse(time, true);
    return DateTime(
        now.year, now.month, now.day, dateTime.hour, dateTime.minute);
  }

  // Validate the TextField with 'h:mm a' time format
  static bool validateTime(String? time) {
    final timeExp = RegExp(r'^(0[1-9]|1[0-2]):[0-5][0-9] (AM|PM)$');
    if (time == null || time.isEmpty) {
      return false;
    }
    if (!timeExp.hasMatch(time)) {
      return false;
    }
    return true;
  }
}
