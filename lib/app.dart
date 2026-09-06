import 'package:flutter/material.dart';
import 'package:tripora/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
class TriporaApp extends StatelessWidget {
  const TriporaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}