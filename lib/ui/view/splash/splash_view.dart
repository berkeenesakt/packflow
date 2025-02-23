import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:packpal/core/router/app_router.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    final isFirstLaunch = Hive.box<bool>('app').get('isFirstLaunch', defaultValue: true)!;
    if (isFirstLaunch) {
      _navigateToOnboarding();
    } else {
      _navigateToHome();
    }
  }

  Future<void> _navigateToOnboarding() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    await context.router.replace(const OnboardingRoute());
  }

  Future<void> _navigateToHome() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    await context.router.replace(const HomeRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.backpack_outlined,
              size: 120,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'PackPal',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
