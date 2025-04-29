import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:packflow/core/router/app_router.dart';
import 'package:packflow/core/services/notification_service.dart';
import 'package:packflow/generated/locale_keys.g.dart';

@RoutePage()
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final NotificationService _notificationService = NotificationService();
  bool _requestingPermission = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.checklist_rounded,
      title: LocaleKeys.onboarding_create_packing_lists.tr(),
      description: LocaleKeys.onboarding_never_forget_essential_items_with_smart_packing_lists.tr(),
    ),
    OnboardingPage(
      icon: Icons.category_rounded,
      title: LocaleKeys.onboarding_organize_by_categories.tr(),
      description: LocaleKeys.onboarding_keep_your_items_organized_in_custom_categories.tr(),
    ),
    OnboardingPage(
      icon: Icons.notifications_active_rounded,
      title: LocaleKeys.onboarding_smart_reminders.tr(),
      description: LocaleKeys.onboarding_get_reminded_to_check_your_list_before_departure.tr(),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _requestingPermission = true;
    });

    try {
      await _notificationService.initialize();

      // Request permissions
      //await _notificationService.requestPermissions();

      // Schedule notifications for any existing packing lists
      await _notificationService.scheduleAllPackingReminders();

      // Mark onboarding as completed and navigate to home
      await Hive.box<bool>('app').put('isFirstLaunch', false);
      if (mounted) {
        await context.router.replace(const NavigationRoute());
      }
    } catch (e) {
      // Handle permission errors if any
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(LocaleKeys.onboarding_notification_permission_failed.tr()),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _requestingPermission = false;
        });
      }
    }
  }

  void _skipNotifications() {
    Hive.box<bool>('app').put('isFirstLaunch', false);
    context.router.replace(const NavigationRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageView(page: page);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_currentPage == _pages.length - 1) ...[
                    FilledButton(
                      onPressed: _requestingPermission ? null : _requestNotificationPermission,
                      child: _requestingPermission
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(LocaleKeys.onboarding_requesting_permissions.tr()),
                              ],
                            )
                          : Text(LocaleKeys.onboarding_enable_notifications.tr()),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _skipNotifications,
                      child: Text(LocaleKeys.onboarding_skip.tr()),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
