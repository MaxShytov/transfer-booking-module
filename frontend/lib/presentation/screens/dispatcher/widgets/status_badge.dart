import 'package:flutter/material.dart';

/// Status badge widget for booking status display.
class StatusBadge extends StatelessWidget {
  final String status;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: config.color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: isCompact ? 12 : 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'pending':
        return _StatusConfig(
          label: 'В ожидании',
          color: Colors.amber.shade600,
          icon: Icons.schedule,
        );
      case 'confirmed':
        return _StatusConfig(
          label: 'Подтверждено',
          color: Colors.blue.shade600,
          icon: Icons.check_circle_outline,
        );
      case 'in_progress':
        return _StatusConfig(
          label: 'В пути',
          color: Colors.purple.shade600,
          icon: Icons.local_shipping,
        );
      case 'completed':
        return _StatusConfig(
          label: 'Завершено',
          color: Colors.green.shade600,
          icon: Icons.check_circle,
        );
      case 'cancelled':
        return _StatusConfig(
          label: 'Отменено',
          color: Colors.red.shade600,
          icon: Icons.cancel,
        );
      default:
        return _StatusConfig(
          label: status,
          color: Colors.grey,
          icon: Icons.help_outline,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// Payment status badge widget.
class PaymentStatusBadge extends StatelessWidget {
  final String paymentStatus;
  final bool isCompact;

  const PaymentStatusBadge({
    super.key,
    required this.paymentStatus,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getPaymentStatusConfig(paymentStatus);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 10,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.textColor,
          fontSize: isCompact ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _PaymentStatusConfig _getPaymentStatusConfig(String status) {
    switch (status) {
      case 'unpaid':
        return _PaymentStatusConfig(
          label: 'Не оплачено',
          bgColor: Colors.red.shade100,
          textColor: Colors.red.shade800,
        );
      case 'deposit_paid':
        return _PaymentStatusConfig(
          label: 'Депозит внесён',
          bgColor: Colors.yellow.shade100,
          textColor: Colors.yellow.shade800,
        );
      case 'fully_paid':
        return _PaymentStatusConfig(
          label: 'Оплачено',
          bgColor: Colors.green.shade100,
          textColor: Colors.green.shade800,
        );
      case 'refunded':
        return _PaymentStatusConfig(
          label: 'Возврат',
          bgColor: Colors.grey.shade100,
          textColor: Colors.grey.shade800,
        );
      default:
        return _PaymentStatusConfig(
          label: status,
          bgColor: Colors.grey.shade100,
          textColor: Colors.grey.shade800,
        );
    }
  }
}

class _PaymentStatusConfig {
  final String label;
  final Color bgColor;
  final Color textColor;

  _PaymentStatusConfig({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });
}
