import 'package:flutter/cupertino.dart';

import '../../../data/models/extra_fee.dart';

/// Tile for extra fee selection - Cupertino style.
class ExtraFeeTile extends StatelessWidget {
  final ExtraFee fee;
  final bool isSelected;
  final int quantity;
  final int minQuantity;
  final String? minQuantityHint;
  final ValueChanged<bool>? onToggle;
  final ValueChanged<int>? onQuantityChanged;

  const ExtraFeeTile({
    super.key,
    required this.fee,
    this.isSelected = false,
    this.quantity = 1,
    this.minQuantity = 1,
    this.minQuantityHint,
    this.onToggle,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final showQuantity = isSelected;
    final totalPrice = fee.amount * quantity;

    return GestureDetector(
      onTap: () => onToggle?.call(!isSelected),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.systemBlue
                : CupertinoColors.separator.resolveFrom(context),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CupertinoColors.systemBlue.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? CupertinoColors.systemBlue
                      : const Color(0x00000000),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.separator.resolveFrom(context),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        CupertinoIcons.checkmark,
                        size: 16,
                        color: CupertinoColors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee.feeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.label,
                      ),
                    ),
                    if (fee.description.isNotEmpty)
                      Text(
                        fee.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    // Quantity selector
                    if (showQuantity) ...[
                      const SizedBox(height: 8),
                      _CupertinoQuantitySelector(
                        quantity: quantity,
                        minQuantity: minQuantity,
                        onChanged: onQuantityChanged,
                      ),
                      // Minimum quantity hint
                      if (minQuantity > 0 && minQuantityHint != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.info_circle,
                              size: 14,
                              color: CupertinoColors.systemOrange.resolveFrom(context),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              minQuantityHint!,
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.systemOrange.resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '€${fee.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                  Text(
                    'each',
                    style: TextStyle(
                      fontSize: 11,
                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                    ),
                  ),
                  if (isSelected && quantity > 1)
                    Text(
                      '= €${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.systemGreen,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CupertinoQuantitySelector extends StatelessWidget {
  final int quantity;
  final int minQuantity;
  final ValueChanged<int>? onChanged;

  const _CupertinoQuantitySelector({
    required this.quantity,
    this.minQuantity = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            minimumSize: Size.zero,
            onPressed: quantity > minQuantity ? () => onChanged?.call(quantity - 1) : null,
            child: Icon(
              CupertinoIcons.minus,
              size: 18,
              color: quantity > minQuantity
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.label,
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            minimumSize: Size.zero,
            onPressed: () => onChanged?.call(quantity + 1),
            child: const Icon(
              CupertinoIcons.plus,
              size: 18,
              color: CupertinoColors.systemBlue,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact display of selected extra fee for summary - Cupertino style.
class ExtraFeeChip extends StatelessWidget {
  final ExtraFee fee;
  final int quantity;
  final VoidCallback? onRemove;

  const ExtraFeeChip({
    super.key,
    required this.fee,
    this.quantity = 1,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final total = fee.calculateFee(quantity: quantity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quantity > 1
                ? '${fee.feeName} x$quantity (€${total.toStringAsFixed(2)})'
                : '${fee.feeName} (€${total.toStringAsFixed(2)})',
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemBlue,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                CupertinoIcons.xmark_circle_fill,
                size: 16,
                color: CupertinoColors.systemBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
