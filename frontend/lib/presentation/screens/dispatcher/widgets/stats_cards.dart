import 'package:flutter/material.dart';

import '../../../../data/models/dispatcher_models.dart';

/// Stats cards widget for dispatcher dashboard.
class StatsCardsRow extends StatelessWidget {
  final DispatcherStats stats;

  const StatsCardsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _StatCard(
            title: 'Сегодня',
            value: '${stats.todayTransfers}',
            subtitle: '${stats.todayRevenue.toStringAsFixed(0)} EUR',
            icon: Icons.today,
            color: Colors.blue,
          ),
          _StatCard(
            title: 'В ожидании',
            value: '${stats.pendingCount}',
            icon: Icons.schedule,
            color: Colors.amber,
          ),
          _StatCard(
            title: 'Без водителя',
            value: '${stats.unassignedCount}',
            icon: Icons.person_off,
            color: Colors.orange,
          ),
          _StatCard(
            title: 'Не оплачено',
            value: '${stats.unpaidCount}',
            icon: Icons.payment,
            color: Colors.red,
          ),
          _StatCard(
            title: 'Водители',
            value: '${stats.driversAvailable}/${stats.driversTotal}',
            icon: Icons.drive_eta,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(right: 8),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
