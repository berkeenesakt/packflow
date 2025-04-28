import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/widgets/date_range_picker/colors.dart';
import 'package:packflow/ui/widgets/date_range_picker/data.dart';
import 'package:packflow/ui/widgets/date_range_picker/date_methods.dart';
import 'package:packflow/ui/widgets/date_range_picker/widgets/cell.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// A dialog that allows users to select a date range.
///
/// Returns a [DateTimeRange] when the Save button is pressed,
/// or null when the dialog is dismissed.
class DateRangePickerDialog extends StatefulWidget {
  /// Creates a date range picker dialog.
  const DateRangePickerDialog({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
  });

  /// The initially selected start date when the dialog is first displayed.
  final DateTime? initialStartDate;

  /// The initially selected end date when the dialog is first displayed.
  final DateTime? initialEndDate;

  @override
  State<DateRangePickerDialog> createState() => _DateRangePickerDialogState();

  /// Shows a date range picker dialog.
  ///
  /// The returned Future resolves to the date range selected by the user when the user
  /// confirms the dialog. If the user cancels the dialog, the Future resolves to null.
  static Future<DateTimeRange?> show(
    BuildContext context, {
    DateTime? initialStartDate,
    DateTime? initialEndDate,
  }) {
    return showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: DateRangePickerDialog(
          initialStartDate: initialStartDate,
          initialEndDate: initialEndDate,
        ),
      ),
    );
  }
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime? tempEndDate;

  final datePickerController = DateRangePickerController();
  final minDate = CalendarData.minDate;
  final maxDate = CalendarData.maxDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;

    if (startDate != null || endDate != null) {
      datePickerController.selectedRange = PickerDateRange(startDate, endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Theme(
        data: ThemeData(primaryColor: ColorConstants.colorPrimary, useMaterial3: false),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 50),
                GestureDetector(
                  onTap: () {
                    if (datePickerController.displayDate != null) {
                      setState(() {
                        datePickerController.backward!();
                      });
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('MMMM yyyy').format(datePickerController.displayDate ?? DateTime.now()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (datePickerController.displayDate != null) {
                      setState(() {
                        datePickerController.forward!();
                      });
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
            // Calendar
            SfDateRangePicker(
              minDate: minDate,
              maxDate: maxDate,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                dayFormat: 'E',
                viewHeaderHeight: 50,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              headerHeight: 0,
              allowViewNavigation: false,
              todayHighlightColor: Colors.black,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
                final range = datePickerController.selectedRange ?? const PickerDateRange(null, null);
                if ((range.startDate == null ? false : DateMethods.isCellUnavailable(range.startDate!)) ||
                    (range.endDate == null ? false : DateMethods.isCellUnavailable(range.endDate!))) {
                  setState(() {
                    datePickerController.selectedRange = PickerDateRange(startDate, endDate);
                  });
                } else if (range.startDate == range.endDate) {
                  setState(() {
                    startDate = range.startDate;
                    endDate = null;
                    datePickerController.selectedRange = PickerDateRange(startDate, endDate);
                  });
                } else if (DateMethods.isCheckInDate(range.startDate!)) {
                  if (range.endDate != null) {
                    log('case 1');
                    setState(() {
                      startDate = tempEndDate == range.endDate ? range.startDate : range.endDate;
                      tempEndDate = range.endDate;
                      endDate = null;
                      datePickerController.selectedRange = PickerDateRange(startDate, endDate);
                    });
                    return;
                  } else {
                    if (DateMethods.isRangeAvailable(range.startDate, range.endDate) && range.endDate != null) {
                      log('case 2');
                      setState(() {
                        startDate = range.startDate;
                        endDate = range.endDate;
                      });
                      return;
                    } else {
                      log('case 3');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 1),
                          content: Text(LocaleKeys.date_picker_unavailable_checkout_error.tr()),
                        ),
                      );
                      setState(() {
                        startDate = null;
                        endDate = null;
                        tempEndDate = null;
                        datePickerController.selectedRange = PickerDateRange(range.startDate, null);
                      });
                    }
                  }
                } else if (DateMethods.isRangeAvailable(range.startDate, range.endDate)) {
                  setState(() {
                    startDate = range.startDate;
                    endDate = range.endDate;
                  });
                } else {
                  if (DateMethods.isRangeCheckinAndCheckout(range.startDate, range.endDate)) {
                    log('case 6');
                    setState(() {
                      startDate = range.startDate;
                      endDate = range.endDate;
                    });
                  } else {
                    log('case 5');
                    setState(() {
                      startDate = startDate == range.startDate ? range.endDate ?? range.startDate : range.startDate;
                      endDate = null;
                      datePickerController.selectedRange = PickerDateRange(startDate, endDate);
                    });
                  }
                }
              },
              controller: datePickerController,
              selectionMode: DateRangePickerSelectionMode.range,
              rangeSelectionColor: ColorConstants.backgroundColor,
              endRangeSelectionColor: Colors.transparent,
              startRangeSelectionColor: Colors.transparent,
              rangeTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              cellBuilder: (context, cellDetails) {
                final isUnavailable = DateMethods.isCellUnavailable(cellDetails.date);
                final isRangeStart = datePickerController.selectedRange == null
                    ? false
                    : (cellDetails.date == datePickerController.selectedRange!.startDate);
                final isRangeEnd = datePickerController.selectedRange == null
                    ? false
                    : cellDetails.date == datePickerController.selectedRange!.endDate;
                final isRange = isRangeStart || isRangeEnd;
                final isRangeMiddle = datePickerController.selectedRange == null
                    ? false
                    : datePickerController.selectedRange!.endDate == null
                        ? false
                        : (cellDetails.date.isAfter(datePickerController.selectedRange!.startDate!) &&
                            cellDetails.date.isBefore(datePickerController.selectedRange!.endDate!));
                return CalendarCell(
                  isRangeStart: isRangeStart,
                  isRangeEnd: isRangeEnd,
                  datePickerController: datePickerController,
                  cellDetails: cellDetails,
                  isRangeMiddle: isRangeMiddle,
                  isRange: isRange,
                  isUnavailable: isUnavailable,
                  isCheckout: DateMethods.isDateCheckinAndCheckoutDate(cellDetails.date)
                      ? false
                      : ((datePickerController.selectedRange ?? const PickerDateRange(null, null)).startDate ==
                              cellDetails.date &&
                          DateMethods.isCheckInDate(cellDetails.date)),
                );
              },
            ),
            // Add confirmation buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(LocaleKeys.date_picker_cancel.tr()),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: startDate != null
                        ? () {
                            if (endDate == null && startDate!.isBefore(DateTime.now())) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 1),
                                  content: Text(LocaleKeys.date_picker_travel_date_past_error.tr()),
                                ),
                              );
                            } else if (endDate != null && endDate!.isBefore(DateTime.now())) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 1),
                                  content: Text(LocaleKeys.date_picker_end_date_past_error.tr()),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop(
                                DateTimeRange(
                                  start: startDate!,
                                  end: endDate ?? startDate!,
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(LocaleKeys.date_picker_confirm.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
