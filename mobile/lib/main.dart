import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/storage/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage Service
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  // Determine initial route based on onboarding completion
  final bool hasOnboarded = storageService.hasCompletedOnboarding();
  final String initialRoute = hasOnboarded ? Routes.home : Routes.onboarding;

  runApp(FireAlertApp(initialRoute: initialRoute));
}

class FireAlertApp extends StatelessWidget {
  final String initialRoute;

  const FireAlertApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
