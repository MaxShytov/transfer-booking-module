import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/dispatcher_models.dart';
import '../../../providers/dispatcher_providers.dart';
import 'status_badge.dart';
import 'driver_picker.dart';

/// Booking detail panel for master-detail view.
class BookingDetailPanel extends ConsumerWidget {
  final DispatcherBookingDetail booking;

  const BookingDetailPanel({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsState = ref.watch(dispatcherActionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _Header(booking: booking),
          const SizedBox(height: 16),

          // Quick actions
          _QuickActions(booking: booking),
          const SizedBox(height: 16),

          // Status section
          _StatusSection(booking: booking),
          const SizedBox(height: 16),

          // Route info
          _RouteSection(booking: booking),
          const SizedBox(height: 16),

          // Customer info
          _CustomerSection(booking: booking),
          const SizedBox(height: 16),

          // Trip details
          _TripDetailsSection(booking: booking),
          const SizedBox(height: 16),

          // Driver info
          _DriverSection(booking: booking),
          const SizedBox(height: 16),

          // Pricing
          _PricingSection(booking: booking),
          const SizedBox(height: 16),

          // Notes
          _NotesSection(booking: booking),

          // Loading overlay
          if (actionsState.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _Header({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.bookingReference,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Создано: ${_formatDateTime(booking.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${booking.finalPrice.toStringAsFixed(2)} ${booking.currency}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (booking.isRoundTrip)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Туда-обратно',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr);
      return DateFormat('dd.MM.yyyy HH:mm').format(dt);
    } catch (_) {
      return dateTimeStr;
    }
  }
}

class _QuickActions extends ConsumerWidget {
  final DispatcherBookingDetail booking;

  const _QuickActions({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(dispatcherActionsProvider.notifier);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Status change buttons
        if (booking.status == 'pending')
          _ActionButton(
            label: 'Подтвердить',
            icon: Icons.check,
            color: Colors.blue,
            onPressed: () => _confirmBooking(context, ref, actions),
          ),

        if (booking.status == 'confirmed')
          _ActionButton(
            label: 'Начать',
            icon: Icons.play_arrow,
            color: Colors.purple,
            onPressed: () => actions.updateStatus(booking.id, 'in_progress'),
          ),

        if (booking.status == 'in_progress')
          _ActionButton(
            label: 'Завершить',
            icon: Icons.check_circle,
            color: Colors.green,
            onPressed: () => actions.updateStatus(booking.id, 'completed'),
          ),

        if (booking.status != 'cancelled' && booking.status != 'completed')
          _ActionButton(
            label: 'Отменить',
            icon: Icons.cancel,
            color: Colors.red,
            onPressed: () => _cancelBooking(context, ref, actions),
          ),

        // Driver assignment
        if (booking.status != 'cancelled' && booking.status != 'completed')
          _ActionButton(
            label: booking.hasDriver ? 'Сменить водителя' : 'Назначить',
            icon: Icons.drive_eta,
            color: booking.hasDriver ? Colors.teal : Colors.orange,
            onPressed: () => _assignDriver(context, ref, actions),
          ),

        // Payment status
        if (booking.paymentStatus != 'fully_paid' &&
            booking.status != 'cancelled')
          _ActionButton(
            label: 'Оплачено',
            icon: Icons.payment,
            color: Colors.green,
            onPressed: () => actions.updatePaymentStatus(booking.id, 'fully_paid'),
          ),
      ],
    );
  }

  Future<void> _confirmBooking(
    BuildContext context,
    WidgetRef ref,
    DispatcherActionsNotifier actions,
  ) async {
    await actions.updateStatus(booking.id, 'confirmed');
  }

  Future<void> _cancelBooking(
    BuildContext context,
    WidgetRef ref,
    DispatcherActionsNotifier actions,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _CancelReasonDialog(),
    );
    if (reason != null && context.mounted) {
      await actions.updateStatus(
        booking.id,
        'cancelled',
        cancellationReason: reason,
      );
    }
  }

  Future<void> _assignDriver(
    BuildContext context,
    WidgetRef ref,
    DispatcherActionsNotifier actions,
  ) async {
    final driverId = await showDriverPicker(
      context,
      currentDriverId: booking.assignedDriverId,
    );
    if (driverId != null || booking.hasDriver) {
      // Only update if we got a selection (including unassign)
      await actions.assignDriver(booking.id, driverId);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _StatusSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            StatusBadge(status: booking.status),
            const SizedBox(width: 12),
            PaymentStatusBadge(paymentStatus: booking.paymentStatus),
          ],
        ),
      ),
    );
  }
}

class _RouteSection extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _RouteSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Маршрут',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Date and time
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _formatDate(booking.serviceDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _formatTime(booking.pickupTime),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Pickup
            _AddressRow(
              label: 'Откуда',
              address: booking.pickupAddress,
              notes: booking.pickupNotes,
              color: Colors.green,
            ),
            const SizedBox(height: 8),

            // Dropoff
            _AddressRow(
              label: 'Куда',
              address: booking.dropoffAddress,
              notes: booking.dropoffNotes,
              color: Colors.red,
            ),

            // Distance info
            if (booking.distanceKm != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.route, size: 14, color: theme.colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    '${booking.distanceKm!.toStringAsFixed(1)} км',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (booking.durationMinutes != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.timer, size: 14, color: theme.colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      '~${booking.durationMinutes} мин',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],

            // Return trip
            if (booking.isRoundTrip && booking.returnDate != null) ...[
              const Divider(height: 24),
              Text(
                'Обратный рейс',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(_formatDate(booking.returnDate!)),
                  if (booking.returnTime != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.access_time,
                        size: 16, color: theme.colorScheme.secondary),
                    const SizedBox(width: 8),
                    Text(_formatTime(booking.returnTime!)),
                  ],
                ],
              ),
            ],

            // Flight number
            if (booking.flightNumber != null &&
                booking.flightNumber!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.flight,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('Рейс: ${booking.flightNumber}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy', 'ru').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }
}

class _AddressRow extends StatelessWidget {
  final String label;
  final String address;
  final String? notes;
  final Color color;

  const _AddressRow({
    required this.label,
    required this.address,
    this.notes,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: theme.textTheme.bodyMedium,
              ),
              if (notes != null && notes!.isNotEmpty)
                Text(
                  notes!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 16),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: address));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Адрес скопирован')),
            );
          },
          tooltip: 'Копировать',
          iconSize: 16,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ],
    );
  }
}

class _CustomerSection extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _CustomerSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Клиент',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _ContactRow(
              icon: Icons.person,
              value: booking.customerName,
            ),
            const SizedBox(height: 8),
            _ContactRow(
              icon: Icons.phone,
              value: booking.customerPhone,
              onTap: () => _launchPhone(booking.customerPhone),
            ),
            const SizedBox(height: 8),
            _ContactRow(
              icon: Icons.email,
              value: booking.customerEmail,
              onTap: () => _launchEmail(booking.customerEmail),
            ),
            if (booking.specialRequests != null &&
                booking.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.specialRequests!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onTap != null ? theme.colorScheme.primary : null,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.open_in_new,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _TripDetailsSection extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _TripDetailsSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Детали поездки',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _DetailChip(
                  icon: Icons.people,
                  label: '${booking.numPassengers} пасс.',
                ),
                _DetailChip(
                  icon: Icons.luggage,
                  label: '${booking.numLargeLuggage + booking.numSmallLuggage} багаж',
                ),
                _DetailChip(
                  icon: Icons.directions_car,
                  label: booking.vehicleClassName,
                ),
                if (booking.hasChildren)
                  _DetailChip(
                    icon: Icons.child_care,
                    label: 'С детьми',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DriverSection extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _DriverSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final driver = booking.assignedDriverInfo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Водитель',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (driver != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Icon(Icons.person, color: Colors.green.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.displayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (driver.vehicleModel != null)
                          Text(
                            '${driver.vehicleModel} (${driver.vehiclePlate})',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (driver.phone.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () => _launchPhone(driver.phone),
                      color: Colors.green,
                    ),
                ],
              ),
            ] else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Text(
                      'Водитель не назначен',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.orange.shade800,
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

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _PricingSection extends StatelessWidget {
  final DispatcherBookingDetail booking;

  const _PricingSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Стоимость',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _PriceRow(label: 'Базовая цена', value: booking.basePrice),
            if (booking.vehicleClassMultiplier != 1.0)
              _PriceRow(
                label: 'Класс авто (x${booking.vehicleClassMultiplier})',
                value: null,
              ),
            if (booking.seasonalMultiplier != 1.0)
              _PriceRow(
                label: 'Сезон (x${booking.seasonalMultiplier})',
                value: null,
              ),
            _PriceRow(label: 'Подытог', value: booking.subtotal),
            if (booking.extraFeesTotal > 0)
              _PriceRow(label: 'Доп. услуги', value: booking.extraFeesTotal),
            const Divider(),
            _PriceRow(
              label: 'ИТОГО',
              value: booking.finalPrice,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double? value;
  final bool isBold;

  const _PriceRow({
    required this.label,
    this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
          if (value != null)
            Text(
              '${value!.toStringAsFixed(2)} EUR',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _NotesSection extends ConsumerStatefulWidget {
  final DispatcherBookingDetail booking;

  const _NotesSection({required this.booking});

  @override
  ConsumerState<_NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<_NotesSection> {
  late TextEditingController _notesController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _notesController =
        TextEditingController(text: widget.booking.dispatcherNotes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Заметки диспетчера',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => setState(() => _isEditing = true),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isEditing) ...[
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Добавьте заметку...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _notesController.text =
                          widget.booking.dispatcherNotes ?? '';
                      setState(() => _isEditing = false);
                    },
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveNotes,
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ] else
              Text(
                widget.booking.dispatcherNotes?.isNotEmpty == true
                    ? widget.booking.dispatcherNotes!
                    : 'Нет заметок',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: widget.booking.dispatcherNotes?.isNotEmpty != true
                      ? theme.colorScheme.onSurfaceVariant
                      : null,
                  fontStyle: widget.booking.dispatcherNotes?.isNotEmpty != true
                      ? FontStyle.italic
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNotes() async {
    final actions = ref.read(dispatcherActionsProvider.notifier);
    await actions.updateNotes(
      widget.booking.id,
      dispatcherNotes: _notesController.text,
    );
    if (mounted) {
      setState(() => _isEditing = false);
    }
  }
}

class _CancelReasonDialog extends StatefulWidget {
  @override
  State<_CancelReasonDialog> createState() => _CancelReasonDialogState();
}

class _CancelReasonDialogState extends State<_CancelReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Причина отмены'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Укажите причину отмены бронирования',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Отменить заказ'),
        ),
      ],
    );
  }
}
