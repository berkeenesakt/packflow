import 'package:flutter/material.dart';
import 'package:packflow/ui/widgets/date_range_picker/colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.datePickerController,
    required this.cellDetails,
    required this.isRangeMiddle,
    required this.isRange,
    required this.isUnavailable,
    super.key,
    this.isCheckout = false,
  });

  final bool isRangeStart;
  final bool isRangeEnd;
  final DateRangePickerController datePickerController;
  final DateRangePickerCellDetails cellDetails;
  final bool isRangeMiddle;
  final bool isRange;
  final bool isUnavailable;
  final bool isCheckout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: isRangeStart ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isRangeStart ? const Radius.circular(100) : Radius.zero,
                bottomLeft: isRangeStart ? const Radius.circular(100) : Radius.zero,
                topRight: isRangeEnd ? const Radius.circular(100) : Radius.zero,
                bottomRight: isRangeEnd ? const Radius.circular(100) : Radius.zero,
              ),
              color: (isRangeEnd || isRangeStart) && datePickerController.selectedRange!.endDate != null
                  ? ColorConstants.backgroundColor
                  : null,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isCheckout
                ? Colors.transparent
                : isRangeMiddle
                    ? Colors.transparent
                    : isRange
                        ? ColorConstants.selectedCell
                        : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: isCheckout ? Colors.black : Colors.transparent, width: isCheckout ? 1 : 0),
          ),
          child: Center(
            child: Text(
              cellDetails.date.day.toString(),
              style: TextStyle(
                color: isCheckout
                    ? Colors.black
                    : isRangeMiddle
                        ? Colors.black
                        : isRange
                            ? Colors.white
                            : isUnavailable
                                ? ColorConstants.grey500
                                : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: isUnavailable ? TextDecoration.lineThrough : null,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
