import 'package:flutter/cupertino.dart';

/// Helper class for showing date time picker modal.
class DateTimePickerModal {
  DateTimePickerModal._();

  /// Shows the modal and returns the result.
  static Future<DateTimePickerResult?> show({
    required BuildContext context,
    required DateTime initialDate,
    String? initialTime,
    required bool isArrival,
    required String departureLabel,
    required String arrivalLabel,
    required String hourLabel,
    required String minuteLabel,
    required String applyLabel,
    required String todayLabel,
  }) async {
    DateTime selectedDate = initialDate;
    int selectedHour = 12;
    int selectedMinute = 0;
    bool selectedIsArrival = isArrival;

    // Parse initial time if provided
    if (initialTime != null && initialTime.contains(':')) {
      final parts = initialTime.split(':');
      if (parts.length == 2) {
        selectedHour = int.tryParse(parts[0]) ?? 12;
        selectedMinute = int.tryParse(parts[1]) ?? 0;
      }
    }

    final result = await showCupertinoModalPopup<DateTimePickerResult>(
      context: context,
      builder: (context) => _DateTimePickerContent(
        initialDate: selectedDate,
        initialHour: selectedHour,
        initialMinute: selectedMinute,
        isArrival: selectedIsArrival,
        departureLabel: departureLabel,
        arrivalLabel: arrivalLabel,
        hourLabel: hourLabel,
        minuteLabel: minuteLabel,
        applyLabel: applyLabel,
        todayLabel: todayLabel,
      ),
    );

    return result;
  }
}

/// Result from the date time picker.
class DateTimePickerResult {
  final DateTime date;
  final String time;
  final bool isArrival;

  DateTimePickerResult({
    required this.date,
    required this.time,
    required this.isArrival,
  });
}

/// Internal content widget for the modal.
class _DateTimePickerContent extends StatefulWidget {
  final DateTime initialDate;
  final int initialHour;
  final int initialMinute;
  final bool isArrival;
  final String departureLabel;
  final String arrivalLabel;
  final String hourLabel;
  final String minuteLabel;
  final String applyLabel;
  final String todayLabel;

  const _DateTimePickerContent({
    required this.initialDate,
    required this.initialHour,
    required this.initialMinute,
    required this.isArrival,
    required this.departureLabel,
    required this.arrivalLabel,
    required this.hourLabel,
    required this.minuteLabel,
    required this.applyLabel,
    required this.todayLabel,
  });

  @override
  State<_DateTimePickerContent> createState() => _DateTimePickerContentState();
}

class _DateTimePickerContentState extends State<_DateTimePickerContent> {
  late DateTime _selectedDate;
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isArrival;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
    _isArrival = widget.isArrival;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  List<DateTime> _generateDateList() {
    final today = DateTime.now();
    final dates = <DateTime>[];
    for (int i = 0; i < 365; i++) {
      dates.add(DateTime(today.year, today.month, today.day + i));
    }
    return dates;
  }

  String _formatDateForPicker(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return widget.todayLabel;
    }

    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} $month';
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDateList();
    final initialDateIndex = dates.indexWhere((d) =>
        d.year == _selectedDate.year &&
        d.month == _selectedDate.month &&
        d.day == _selectedDate.day);

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey3.resolveFrom(context),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),

            // Departure/Arrival toggle
            Padding(
              padding: const EdgeInsets.all(16),
              child: _ModeToggle(
                isArrival: _isArrival,
                departureLabel: widget.departureLabel,
                arrivalLabel: widget.arrivalLabel,
                onChanged: (isArrival) {
                  setState(() {
                    _isArrival = isArrival;
                  });
                },
              ),
            ),

            // Pickers
            Expanded(
              child: Row(
                children: [
                  // Date picker
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: initialDateIndex >= 0 ? initialDateIndex : 0,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedDate = dates[index];
                        });
                      },
                      children: dates
                          .map((date) => Center(
                                child: Text(
                                  _formatDateForPicker(date),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // Hour picker
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            widget.hourLabel,
                            style: TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel
                                  .resolveFrom(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: _hourController,
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedHour = index;
                              });
                            },
                            children: List.generate(
                              24,
                              (index) => Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Separator
                  const Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Minute picker
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            widget.minuteLabel,
                            style: TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel
                                  .resolveFrom(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: _minuteController,
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedMinute = index;
                              });
                            },
                            children: List.generate(
                              60,
                              (index) => Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    final time =
                        '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}';
                    Navigator.of(context).pop(
                      DateTimePickerResult(
                        date: _selectedDate,
                        time: time,
                        isArrival: _isArrival,
                      ),
                    );
                  },
                  child: Text(widget.applyLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Toggle between departure and arrival mode.
class _ModeToggle extends StatelessWidget {
  final bool isArrival;
  final String departureLabel;
  final String arrivalLabel;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({
    required this.isArrival,
    required this.departureLabel,
    required this.arrivalLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: departureLabel,
              isSelected: !isArrival,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _ToggleButton(
              label: arrivalLabel,
              isSelected: isArrival,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.systemBackground.resolveFrom(context)
              : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? CupertinoColors.label.resolveFrom(context)
                  : CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
      ),
    );
  }
}
