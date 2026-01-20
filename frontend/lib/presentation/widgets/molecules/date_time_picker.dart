import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Combined date and time picker widget - Cupertino style.
class DateTimePicker extends StatelessWidget {
  final String dateLabel;
  final String timeLabel;
  final DateTime? selectedDate;
  final String? selectedTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onTimeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  // Localized strings
  final String? selectDatePlaceholder;
  final String? selectTimePlaceholder;
  final String? cancelLabel;
  final String? doneLabel;

  const DateTimePicker({
    super.key,
    this.dateLabel = 'Date',
    this.timeLabel = 'Time',
    this.selectedDate,
    this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.selectDatePlaceholder,
    this.selectTimePlaceholder,
    this.cancelLabel,
    this.doneLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _CupertinoDatePickerField(
            label: dateLabel,
            selectedDate: selectedDate,
            onChanged: onDateChanged,
            firstDate: firstDate,
            lastDate: lastDate,
            enabled: enabled,
            selectPlaceholder: selectDatePlaceholder,
            cancelLabel: cancelLabel,
            doneLabel: doneLabel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _CupertinoTimePickerField(
            label: timeLabel,
            selectedTime: selectedTime,
            onChanged: onTimeChanged,
            enabled: enabled,
            selectPlaceholder: selectTimePlaceholder,
            cancelLabel: cancelLabel,
            doneLabel: doneLabel,
          ),
        ),
      ],
    );
  }
}

/// Date picker field - Cupertino style.
class _CupertinoDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? selectPlaceholder;
  final String? cancelLabel;
  final String? doneLabel;

  const _CupertinoDatePickerField({
    required this.label,
    this.selectedDate,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.selectPlaceholder,
    this.cancelLabel,
    this.doneLabel,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, y');

    return GestureDetector(
      onTap: enabled ? () => _showDatePicker(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.calendar,
              size: 20,
              color: enabled
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedDate != null
                        ? dateFormat.format(selectedDate!)
                        : selectPlaceholder ?? 'Select date',
                    style: TextStyle(
                      fontSize: 15,
                      color: enabled && selectedDate != null
                          ? CupertinoColors.label.resolveFrom(context)
                          : CupertinoColors.tertiaryLabel.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    final now = DateTime.now();
    // Normalize dates to start of day to avoid time comparison issues
    final today = DateTime(now.year, now.month, now.day);
    final first = firstDate != null
        ? DateTime(firstDate!.year, firstDate!.month, firstDate!.day)
        : today;
    final last = lastDate != null
        ? DateTime(lastDate!.year, lastDate!.month, lastDate!.day, 23, 59, 59)
        : today.add(const Duration(days: 365));

    // Ensure initial date is not before minimum date
    DateTime initialDate = selectedDate ?? today;
    if (initialDate.isBefore(first)) {
      initialDate = first;
    }
    DateTime tempDate = initialDate;

    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 280,
        padding: const EdgeInsets.only(top: 6),
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(cancelLabel ?? 'Cancel'),
                  onPressed: () => Navigator.pop(ctx),
                ),
                CupertinoButton(
                  child: Text(doneLabel ?? 'Done'),
                  onPressed: () {
                    onChanged(tempDate);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: first,
                maximumDate: last,
                onDateTimeChanged: (date) {
                  tempDate = date;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Time picker field - Cupertino style.
class _CupertinoTimePickerField extends StatelessWidget {
  final String label;
  final String? selectedTime;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? selectPlaceholder;
  final String? cancelLabel;
  final String? doneLabel;

  const _CupertinoTimePickerField({
    required this.label,
    this.selectedTime,
    required this.onChanged,
    this.enabled = true,
    this.selectPlaceholder,
    this.cancelLabel,
    this.doneLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _showTimePicker(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.clock,
              size: 20,
              color: enabled
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedTime ?? selectPlaceholder ?? 'Select time',
                    style: TextStyle(
                      fontSize: 15,
                      color: enabled && selectedTime != null
                          ? CupertinoColors.label.resolveFrom(context)
                          : CupertinoColors.tertiaryLabel.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    DateTime initialTime = DateTime.now();

    if (selectedTime != null) {
      final parts = selectedTime!.split(':');
      initialTime = DateTime(
        initialTime.year,
        initialTime.month,
        initialTime.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    DateTime tempTime = initialTime;

    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 280,
        padding: const EdgeInsets.only(top: 6),
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(cancelLabel ?? 'Cancel'),
                  onPressed: () => Navigator.pop(ctx),
                ),
                CupertinoButton(
                  child: Text(doneLabel ?? 'Done'),
                  onPressed: () {
                    final formattedTime =
                        '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}';
                    onChanged(formattedTime);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialTime,
                use24hFormat: true,
                onDateTimeChanged: (time) {
                  tempTime = time;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
