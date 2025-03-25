import 'package:packpal/ui/widgets/date_range_picker/data.dart';
import 'package:packpal/ui/widgets/date_range_picker/date_range_picker_model.dart';

class DateMethods {
  static final List<DateRangeModel> bookedDates = CalendarData.bookedDates;
  static final List<DateTime> blockedDates = CalendarData.blockedDates;
  static final DateTime maxDate = CalendarData.maxDate;
  static final DateTime minDate = CalendarData.minDate;
  static List<DateTime> generateDatesBetween(DateTime? startDate, DateTime? endDate) {
    final dates = <DateTime>[];
    if (startDate == null && endDate == null) {
      return dates;
    }
    if (startDate == null) {
      return [endDate!];
    }
    if (endDate == null) {
      return [startDate];
    }
    for (var date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      dates.add(date);
    }
    return dates;
  }

  static bool isCheckInDate(DateTime date) {
    final bookedStartDates = bookedDates.map((e) => e.startDate).toList();
    return bookedStartDates.contains(date);
  }

  static bool isCheckOutDate(DateTime date) {
    final bookedEndDates = bookedDates.map((e) => e.endDate).toList();
    return bookedEndDates.contains(date);
  }

  static bool isDateCheckinAndCheckoutDate(DateTime date) {
    return isCheckInDate(date) && isCheckOutDate(date);
  }

  static bool isDateUnavailable(DateTime date) {
    if (isCheckInDate(date) || isCheckOutDate(date)) {
      return false;
    }
    final isBooked = CalendarData.bookedDates.any((element) {
      return date.isAfter(element.startDate) && date.isBefore(element.endDate);
    });
    final isBlocked = CalendarData.blockedDates.any((element) {
      return element.isAtSameMomentAs(date);
    });

    final isAfter = date.isAfter(maxDate);
    final isBefore = date.isBefore(minDate);
    final isUnavailable = isBooked || isAfter || isBefore || isBlocked;
    return isUnavailable;
  }

  static bool isCellUnavailable(DateTime date) {
    if (blockedDates.contains(date)) {
      return true;
    }
    if (isDateCheckinAndCheckoutDate(date)) {
      return true;
    }
    if (isCheckInDate(date) || isCheckOutDate(date)) {
      return false;
    } else if (isDateUnavailable(date)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isRangeCheckinAndCheckout(DateTime? startDate, DateTime? endDate) {
    final bookedStartDates = bookedDates.map((e) => e.startDate).toList();
    final bookedEndDates = bookedDates.map((e) => e.endDate).toList();

    if (bookedStartDates.contains(endDate) && bookedEndDates.contains(startDate)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isRangeAvailable(DateTime? startDate, DateTime? endDate) {
    final bookedStartDates = bookedDates.map((e) => e.startDate).toList();
    final bookedEndDates = bookedDates.map((e) => e.endDate).toList();
    final rangeDates = generateDatesBetween(startDate, endDate);
    if ((startDate == null ? false : isCellUnavailable(startDate)) ||
        (endDate == null ? false : isCellUnavailable(endDate))) {
      return false;
    }
    if (rangeDates.any(bookedStartDates.contains) && rangeDates.any(bookedEndDates.contains)) {
      return false;
    }
    if (startDate == null ? false : isCheckInDate(startDate)) {
      return !rangeDates.contains(endDate);
    } else {
      if (endDate == null) {
        return !isDateUnavailable(startDate!);
      } else {
        if (rangeDates.any(isDateUnavailable)) {
          return false;
        } else {
          return true;
        }
      }
    }
  }
}
