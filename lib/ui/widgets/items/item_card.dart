import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    super.key,
    this.checkedItems,
  });

  final PackingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final List<PackingItem>? checkedItems;

  @override
  Widget build(BuildContext context) {
    final isChecked = checkedItems?.contains(item) ?? false;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isChecked ? colorScheme.primary.withOpacity(0.3) : colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: isChecked ? colorScheme.surfaceContainerHighest.withOpacity(0.5) : colorScheme.surface,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Dismissible(
              key: Key(item.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => onDelete(),
              confirmDismiss: (direction) async {
                return showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete item'),
                    content: Text('Are you sure you want to delete this item?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isChecked ? colorScheme.surfaceContainerHighest.withOpacity(0.5) : Colors.transparent,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isChecked ? colorScheme.primary : colorScheme.outline,
                          width: 2,
                        ),
                        color: isChecked ? colorScheme.primary : Colors.transparent,
                      ),
                      child: isChecked
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: colorScheme.onPrimary,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                          ),
                          if (item.notes != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.notes!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (item.quantity > 1) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'x${item.quantity}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
