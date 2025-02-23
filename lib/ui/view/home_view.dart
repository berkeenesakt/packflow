import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:packpal/core/repositories/hive_packing_list_repository_impl.dart';
import 'package:packpal/core/router/app_router.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PackPal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(
            title: 'My Packing Lists',
            description: 'Create and manage your packing lists',
            icon: Icons.list_alt,
            onTap: () {
              context.router.push(PackingListsRoute(repository: HivePackingListRepository()));
            },
          ),
          const SizedBox(height: 16),
          const _MenuCard(
            title: 'Templates',
            description: 'Use and manage packing list templates',
            icon: Icons.copy,
          ),
          const SizedBox(height: 16),
          const _MenuCard(
            title: 'Settings',
            description: 'Configure app settings and preferences',
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
