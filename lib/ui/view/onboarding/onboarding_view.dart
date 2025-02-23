import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:packpal/core/router/app_router.dart';
import 'package:packpal/generated/locale_keys.g.dart';

@RoutePage()
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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

  void _continueWithoutLogin() {
    Hive.box<bool>('app').put('isFirstLaunch', false);
    context.router.replace(const HomeRoute());
  }

  void _navigateToLogin() {
    // TODO(berke): Navigate to login screen once it's created.
    // context.router.push(const LoginRoute());
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
                      onPressed: _navigateToLogin,
                      child: Text(LocaleKeys.onboarding_login.tr()),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _continueWithoutLogin,
                      child: Text(LocaleKeys.onboarding_continue_without_login.tr()),
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
