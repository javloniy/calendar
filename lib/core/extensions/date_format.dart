import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String dateFormat() {
    return DateFormat("dd-mm-yyyy").format(this);
  }

  static DateTime fromDateFormat(String date) {
    final [day, month, year] = date.split('-').map(int.parse).toList();
    return DateTime(year, month, day);
  }
}
