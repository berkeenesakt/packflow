import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packpal/core/init/app_init.dart';
import 'package:packpal/core/init/localization.dart';
import 'package:packpal/core/providers/theme_provider.dart';
import 'package:packpal/core/router/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  await AppInit.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'PackPal',
      theme: themeProvider.themeData,
      darkTheme: themeProvider.themeData,
      themeMode: themeProvider.themeMode,
      routerConfig: _appRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
