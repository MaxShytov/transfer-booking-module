import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/dispatcher_models.dart';
import '../../providers/dispatcher_providers.dart';
import 'widgets/booking_card.dart';
import 'widgets/booking_detail_panel.dart';
import 'widgets/filter_bar.dart';
import 'widgets/stats_cards.dart';

/// Main dispatcher dashboard screen with master-detail layout.
class DispatcherScreen extends ConsumerWidget {
  const DispatcherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use side-by-side layout for wide screens
        final isWideScreen = constraints.maxWidth >= 900;

        if (isWideScreen) {
          return _WideLayout();
        } else {
          return _NarrowLayout();
        }
      },
    );
  }
}

/// Wide screen layout with list and detail side by side.
class _WideLayout extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedBookingIdProvider);
    final bookingDetailAsync = selectedId != null
        ? ref.watch(bookingDetailProvider(selectedId))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Диспетчерская'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dispatcherBookingsProvider);
              ref.invalidate(dispatcherStatsProvider);
            },
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left panel - booking list
          SizedBox(
            width: 400,
            child: _BookingListPanel(),
          ),

          // Divider
          const VerticalDivider(width: 1),

          // Right panel - booking detail
          Expanded(
            child: selectedId == null
                ? const _EmptyDetailPanel()
                : bookingDetailAsync!.when(
                    data: (booking) => BookingDetailPanel(booking: booking),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => _ErrorPanel(error: e.toString()),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Narrow screen layout with list only (detail opens as separate screen).
class _NarrowLayout extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Диспетчерская'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dispatcherBookingsProvider);
              ref.invalidate(dispatcherStatsProvider);
            },
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: _BookingListPanel(
        onBookingTap: (booking) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _BookingDetailScreen(bookingId: booking.id),
            ),
          );
        },
      ),
    );
  }
}

/// Booking list panel with filters and stats.
class _BookingListPanel extends ConsumerWidget {
  final void Function(DispatcherBooking)? onBookingTap;

  const _BookingListPanel({this.onBookingTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dispatcherStatsProvider);
    final bookingsAsync = ref.watch(dispatcherBookingsProvider);
    final selectedId = ref.watch(selectedBookingIdProvider);
    final filters = ref.watch(bookingFiltersProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats cards
        statsAsync.when(
          data: (stats) => Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: StatsCardsRow(stats: stats),
          ),
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // Date header
        if (filters.date != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              _formatDateHeader(filters.date!),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // Filters
        const FilterBar(),
        const SizedBox(height: 8),

        // Bookings list
        Expanded(
          child: bookingsAsync.when(
            data: (bookings) {
              if (bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Нет бронирований',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Измените фильтры для поиска',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Group bookings by time
              final grouped = _groupBookingsByTime(bookings);

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(dispatcherBookingsProvider);
                  ref.invalidate(dispatcherStatsProvider);
                },
                child: ListView.builder(
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final group = grouped[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (group.header != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Text(
                              group.header!,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ...group.bookings.map(
                          (booking) => BookingCard(
                            booking: booking,
                            isSelected: booking.id == selectedId,
                            onTap: () {
                              if (onBookingTap != null) {
                                onBookingTap!(booking);
                              } else {
                                ref.read(selectedBookingIdProvider.notifier).state =
                                    booking.id;
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(dispatcherBookingsProvider),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Сегодня, ${DateFormat('d MMMM', 'ru').format(date)}';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Завтра, ${DateFormat('d MMMM', 'ru').format(date)}';
    }
    return DateFormat('EEEE, d MMMM', 'ru').format(date);
  }

  List<_BookingGroup> _groupBookingsByTime(List<DispatcherBooking> bookings) {
    // Group by hour
    final Map<String, List<DispatcherBooking>> groups = {};

    for (final booking in bookings) {
      final hour = booking.pickupTime.substring(0, 2);
      final key = '$hour:00';
      groups.putIfAbsent(key, () => []).add(booking);
    }

    // Sort groups by time
    final sortedKeys = groups.keys.toList()..sort();

    return sortedKeys.map((key) {
      return _BookingGroup(
        header: key,
        bookings: groups[key]!,
      );
    }).toList();
  }
}

class _BookingGroup {
  final String? header;
  final List<DispatcherBooking> bookings;

  _BookingGroup({this.header, required this.bookings});
}

/// Empty detail panel placeholder.
class _EmptyDetailPanel extends StatelessWidget {
  const _EmptyDetailPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Выберите бронирование',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Кликните на заказ слева для просмотра деталей',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error panel for detail view.
class _ErrorPanel extends StatelessWidget {
  final String error;

  const _ErrorPanel({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Separate booking detail screen for narrow layouts.
class _BookingDetailScreen extends ConsumerWidget {
  final int bookingId;

  const _BookingDetailScreen({required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
      ),
      body: bookingAsync.when(
        data: (booking) => BookingDetailPanel(booking: booking),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorPanel(error: error.toString()),
      ),
    );
  }
}
