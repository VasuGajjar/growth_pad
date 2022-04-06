import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(dateTime);
  }

  static String dateToTimeOnly(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String dateToDateAndTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  hh:mm a').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String isoStringToDateTimeString(String dateTime) {
    return DateFormat('dd MMM yyyy  hh:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(time));
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  static bool isAvailable(String? start, String? end, {DateTime? time, bool isoTime = false}) {
    DateTime _currentTime;
    if (time != null) {
      _currentTime = time;
    } else {
      _currentTime = DateTime.now();
    }
    DateTime _start = start != null
        ? isoTime
            ? isoStringToLocalDate(start)
            : DateFormat('HH:mm').parse(start)
        : DateTime(_currentTime.year);
    DateTime _end = end != null
        ? isoTime
            ? isoStringToLocalDate(end)
            : DateFormat('HH:mm').parse(end)
        : DateTime(_currentTime.year, _currentTime.month, _currentTime.day, 23, 59);
    DateTime _startTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _start.hour, _start.minute, _start.second);
    DateTime _endTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _end.hour, _end.minute, _end.second);
    if (_endTime.isBefore(_startTime)) {
      _endTime = _endTime.add(const Duration(days: 1));
    }
    return _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);
  }

  static DateTime stringTimeToDateTime(String time) {
    return DateFormat('HH:mm:ss').parse(time);
  }

  static String stringToStringTime(String dateTime) {
    DateTime inputDate = DateFormat('HH:mm:ss').parse(dateTime);
    return DateFormat('hh:mm a').format(inputDate);
  }
}
