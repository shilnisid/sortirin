import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sortirin/app/routes/app_pages.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/theme/app_theme.dart';

/// Root Sortirin application widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dark status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return GetMaterialApp(
      title: 'Sortirin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      defaultTransition: Transition.fadeIn,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        // Force dark mode globally
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.3,
                ),
          ),
          child: child!,
        );
      },
    );
  }
}
