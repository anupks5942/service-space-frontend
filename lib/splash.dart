import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/auth/pages/login_or_register_screen.dart';
import 'package:frontend/bottom_navbar.dart';
import 'package:frontend/core/constants/app_storage_key.dart';
import 'package:frontend/core/services/storage_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  void _navigateBasedOnAuth() {
    final token = StorageManager.getStringValue(AppStorageKey.token);
    final isAuthenticated = token != null && token.isNotEmpty;

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  isAuthenticated
                      ? const BottomNavbar()
                      : const LoginOrRegisterScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.support_agent, size: 200, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Service Space',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Provide fast service',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
