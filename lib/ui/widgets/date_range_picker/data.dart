import 'package:packpal/ui/widgets/date_range_picker/date_range_picker_model.dart';

class CalendarData {
  static final DateTime maxDate = DateTime(2025, 12, 31);
  static final DateTime minDate = DateTime.now().subtract(const Duration(days: 365));

  static final List<DateRangeModel> bookedDates = [];
  static final List<DateTime> blockedDates = [];
}
