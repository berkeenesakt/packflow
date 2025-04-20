import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packpal/core/repositories/hive_packing_list_repository.dart';
import 'package:packpal/core/router/app_router.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:packpal/ui/widgets/app_filled_button.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.backpack_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.home_no_packing_lists.tr(),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.home_create_your_first.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppFilledButton(
              onPressed: () {
                context.router.push(
                  CreatePackingListRoute(repository: HivePackingListRepository()),
                );
              },
              text: LocaleKeys.home_create_new_list.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
