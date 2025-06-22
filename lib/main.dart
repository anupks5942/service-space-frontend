import 'package:flutter/material.dart';
import 'package:frontend/auth/pages/login_or_register_screen.dart';
import 'package:frontend/auth/providers/auth_provider.dart';
import 'package:frontend/core/constants/app_storage_key.dart';
import 'package:frontend/core/services/storage_manager.dart';
import 'package:frontend/home/pages/home_screen.dart';
import 'package:frontend/home/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.initializeSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final token = StorageManager.getStringValue(AppStorageKey.token);
    final isAuthenticated = token != null && token.isNotEmpty;
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => HomeProvider()),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  textStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home:
                isAuthenticated
                    ? const HomeScreen()
                    : const LoginOrRegisterScreen(),
          ),
        );
      },
    );
  }
}
