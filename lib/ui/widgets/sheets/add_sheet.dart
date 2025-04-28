import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packflow/core/repositories/hive_packing_list_repository.dart';
import 'package:packflow/core/router/app_router.dart';
import 'package:packflow/generated/locale_keys.g.dart';

class AddSheet extends StatelessWidget {
  const AddSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.add_sheet_choose_an_option.tr(),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildOption(
            context,
            Icons.add_circle_outline,
            LocaleKeys.add_sheet_add_item.tr(),
            Colors.blue,
            () {},
          ),
          const SizedBox(height: 16),
          _buildOption(
            context,
            Icons.add_circle_outline,
            LocaleKeys.add_sheet_add_category.tr(),
            Colors.green,
            () {},
          ),
          const SizedBox(height: 16),
          _buildOption(
            context,
            Icons.add_circle_outline,
            LocaleKeys.add_sheet_create_packing_list.tr(),
            Colors.green,
            () {
              Navigator.of(context).pop();
              context.pushRoute(CreatePackingListRoute(repository: HivePackingListRepository()));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    void Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
