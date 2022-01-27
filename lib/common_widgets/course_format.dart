import 'package:intl/intl.dart';
class CourseFormat {
  static String Sems(double Sems) {
    final SemsNotNegative = Sems < 0.0 ? 0.0 : Sems;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(SemsNotNegative);
    return '${formatted}days';
  }

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String currency(int pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }
}
