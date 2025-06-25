import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'auth/pages/login_or_register_screen.dart';
import 'core/constants/app_storage_key.dart';
import 'core/services/storage_manager.dart';
import 'home/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      final token = StorageManager.getStringValue(AppStorageKey.token);
      final isAuthenticated = token != null && token.isNotEmpty;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  isAuthenticated
                      ? const HomeScreen()
                      : const LoginOrRegisterScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.support_agent, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Service Space',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Provide fast service',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
