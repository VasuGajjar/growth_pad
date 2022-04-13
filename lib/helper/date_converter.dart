import 'package:intl/intl.dart';

class DateConverter {
  static String timeToString(DateTime? time, {String output = 'yyyy-MM-dd HH:mm:ss'}) {
    if (time == null) return '';
    return DateFormat(output).format(time);
  }

  static DateTime stringToTime(String? time, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    if (time == null) return DateTime.now();
    return DateFormat(format).parse(time);
  }

  static String changeFormat(String? time, {String input = 'yyyy-MM-dd HH:mm:ss', String output = 'yyyy-MM-dd HH:mm:ss'}) {
    if (time == null) return '';
    return timeToString(stringToTime(time, format: input), output: output);
  }
}
