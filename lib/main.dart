import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packpal/core/init/app_init.dart';
import 'package:packpal/core/init/localization.dart';
import 'package:packpal/core/router/app_router.dart';
import 'package:packpal/core/theme/app_theme.dart';

void main() async {
  await AppInit.init();
  runApp(Localization(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PackPal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _appRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
