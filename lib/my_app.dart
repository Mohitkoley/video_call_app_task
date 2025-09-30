import 'package:flutter/material.dart';
import 'package:video_calling/core/routes/app_router.dart';
import 'package:video_calling/core/service_locator/di.dart';
import 'package:video_calling/core/theme/app_themes.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = getIt<AppRouter>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Video call Demo',
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
      theme: AppThemes.lightThemeData,
    );
  }
}
