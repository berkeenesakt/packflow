import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packflow/core/init/app_init.dart';
import 'package:packflow/core/init/localization.dart';
import 'package:packflow/core/providers/app_settings_provider.dart';
import 'package:packflow/core/router/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  await AppInit.init();

  // Create app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: Localization(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettingsProvider>(context);

    // Apply saved locale
    if (context.locale != appSettings.locale) {
      log('Setting locale to ${appSettings.locale}');
      Future.microtask(() => context.setLocale(appSettings.locale));
    }

    return MaterialApp.router(
      title: 'PackFlow',
      theme: appSettings.themeData,
      darkTheme: appSettings.themeData,
      themeMode: appSettings.themeMode,
      routerConfig: _appRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: appSettings.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
