import 'package:intl/intl.dart';

class DateUtil {

  static String loadDate()
  {
    return DateFormat('d/M/y').format(DateTime.now());
  }

}