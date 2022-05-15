import 'package:intl/intl.dart';

class TimePrint {
  static String format(DateTime targetTime) {
    if (targetTime.compareTo(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) <
        0) {
      return DateFormat('M월 d일', 'en_US').format(targetTime);
    }
    return DateFormat('a h:mm', 'en_US').format(targetTime);
  }

  static String msgFormat(DateTime targetTime) {
    if (targetTime.compareTo(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) <
        0) {
      return DateFormat('M월 d일 a h:mm', 'en_US').format(targetTime);
    }
    return DateFormat('a h:mm', 'en_US').format(targetTime);
  }
}
