import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/dispatcher_providers.dart';

/// Filter bar widget for booking list.
class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(bookingFiltersProvider);
    final filtersNotifier = ref.read(bookingFiltersProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick date filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _QuickFilterChip(
                label: 'Сегодня',
                isSelected: _isToday(filters.date),
                onTap: () => filtersNotifier.showToday(),
              ),
              _QuickFilterChip(
                label: 'Завтра',
                isSelected: _isTomorrow(filters.date),
                onTap: () => filtersNotifier.showTomorrow(),
              ),
              _QuickFilterChip(
                label: 'Все',
                isSelected: !filters.hasActiveFilters,
                onTap: () => filtersNotifier.showAll(),
              ),
              const SizedBox(width: 8),
              const VerticalDivider(width: 1, thickness: 1),
              const SizedBox(width: 8),
              _DatePickerChip(
                date: filters.date,
                onDateSelected: (date) => filtersNotifier.setDate(date),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Status and other filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Status filter
              _DropdownFilterChip<String>(
                label: 'Статус',
                value: filters.status,
                items: const {
                  null: 'Все',
                  'pending': 'В ожидании',
                  'confirmed': 'Подтверждено',
                  'in_progress': 'В пути',
                  'completed': 'Завершено',
                  'cancelled': 'Отменено',
                },
                onChanged: (value) => filtersNotifier.setStatus(value),
              ),
              const SizedBox(width: 8),

              // Payment status filter
              _DropdownFilterChip<String>(
                label: 'Оплата',
                value: filters.paymentStatus,
                items: const {
                  null: 'Все',
                  'unpaid': 'Не оплачено',
                  'deposit_paid': 'Депозит',
                  'fully_paid': 'Оплачено',
                },
                onChanged: (value) => filtersNotifier.setPaymentStatus(value),
              ),
              const SizedBox(width: 8),

              // Unassigned filter
              FilterChip(
                label: const Text('Без водителя'),
                selected: filters.unassigned == true,
                onSelected: (selected) =>
                    filtersNotifier.setUnassigned(selected ? true : null),
                showCheckmark: true,
                labelStyle: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Поиск по имени, телефону, адресу...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: theme.textTheme.bodySmall,
            onChanged: (value) {
              if (value.isEmpty || value.length >= 2) {
                filtersNotifier.setSearch(value.isEmpty ? null : value);
              }
            },
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime? date) {
    if (date == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}

class _QuickFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        labelStyle: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _DatePickerChip extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime?> onDateSelected;

  const _DatePickerChip({
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = date != null && !_isToday(date) && !_isTomorrow(date);

    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 14),
          const SizedBox(width: 4),
          Text(
            isActive ? DateFormat('dd.MM').format(date!) : 'Дата',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      backgroundColor:
          isActive ? theme.colorScheme.primaryContainer : null,
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        onDateSelected(selectedDate);
      },
    );
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime? date) {
    if (date == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}

class _DropdownFilterChip<T> extends StatelessWidget {
  final String label;
  final T? value;
  final Map<T?, String> items;
  final ValueChanged<T?> onChanged;

  const _DropdownFilterChip({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = value != null;

    return PopupMenuButton<T?>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => items.entries
          .map(
            (e) => PopupMenuItem<T?>(
              value: e.key,
              child: Text(e.value),
            ),
          )
          .toList(),
      child: Chip(
        label: Text(
          isActive ? items[value] ?? label : label,
          style: theme.textTheme.bodySmall,
        ),
        backgroundColor:
            isActive ? theme.colorScheme.primaryContainer : null,
        deleteIcon: isActive ? const Icon(Icons.close, size: 16) : null,
        onDeleted: isActive ? () => onChanged(null) : null,
      ),
    );
  }
}
