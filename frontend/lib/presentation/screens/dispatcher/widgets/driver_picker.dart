import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/dispatcher_models.dart';
import '../../../providers/dispatcher_providers.dart';

/// Driver picker dialog.
class DriverPickerDialog extends ConsumerWidget {
  final int? currentDriverId;

  const DriverPickerDialog({
    super.key,
    this.currentDriverId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driversAsync = ref.watch(driversProvider);
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.drive_eta,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Выбор водителя',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),

            // Unassign option
            if (currentDriverId != null)
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person_off, color: Colors.white),
                ),
                title: const Text('Снять назначение'),
                subtitle: const Text('Убрать водителя с заказа'),
                onTap: () => Navigator.of(context).pop(const _DriverSelection(null)),
              ),

            if (currentDriverId != null) const Divider(height: 1),

            // Drivers list
            Expanded(
              child: driversAsync.when(
                data: (drivers) {
                  if (drivers.isEmpty) {
                    return const Center(
                      child: Text('Нет доступных водителей'),
                    );
                  }

                  // Sort: available first, then by name
                  final sortedDrivers = List<DriverInfo>.from(drivers)
                    ..sort((a, b) {
                      if (a.isAvailable != b.isAvailable) {
                        return a.isAvailable ? -1 : 1;
                      }
                      return a.displayName.compareTo(b.displayName);
                    });

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedDrivers.length,
                    itemBuilder: (context, index) {
                      final driver = sortedDrivers[index];
                      final isSelected = driver.id == currentDriverId;

                      return _DriverTile(
                        driver: driver,
                        isSelected: isSelected,
                        onTap: () => Navigator.of(context)
                            .pop(_DriverSelection(driver.id)),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 8),
                      Text('Ошибка загрузки: $error'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(driversProvider),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverTile extends StatelessWidget {
  final DriverInfo driver;
  final bool isSelected;
  final VoidCallback onTap;

  const _DriverTile({
    required this.driver,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      selected: isSelected,
      leading: CircleAvatar(
        backgroundColor: driver.isAvailable
            ? Colors.green.shade100
            : Colors.grey.shade200,
        child: Icon(
          Icons.person,
          color: driver.isAvailable
              ? Colors.green.shade700
              : Colors.grey.shade500,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              driver.displayName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!driver.isAvailable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Занят',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (driver.vehicleModel != null)
            Text(
              '${driver.vehicleModel} (${driver.vehiclePlate})',
              style: theme.textTheme.bodySmall,
            ),
          if (driver.activeBookingsCount > 0)
            Text(
              'Заказов: ${driver.activeBookingsCount}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
        ],
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

/// Helper class for driver selection result.
class _DriverSelection {
  final int? driverId;
  const _DriverSelection(this.driverId);
}

/// Shows driver picker dialog and returns selected driver ID.
/// Returns null if dialog was cancelled, or [_DriverSelection] with driver ID (can be null to unassign).
Future<int?> showDriverPicker(
  BuildContext context, {
  int? currentDriverId,
}) async {
  final result = await showDialog<_DriverSelection>(
    context: context,
    builder: (context) => DriverPickerDialog(currentDriverId: currentDriverId),
  );
  return result?.driverId;
}
