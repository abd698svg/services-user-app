import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait a brief moment for the splash screen presentation (e.g., 1.5 seconds)
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Read stored Sanctum token
      final token = await _secureStorage.read(key: 'auth_token');

      if (token == null) {
        // No token found, navigate to login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      // Verify token with Laravel backend API GET /user
      // - Android Emulator: 'http://10.0.2.2:8000/api/user'
      // - iOS Simulator / Desktop / Localhost: 'http://127.0.0.1:8000/api/user'
      final url = Uri.parse('http://127.0.0.1:8000/api/user');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          // Token is valid, proceed to Home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Token is invalid or expired, clear it and go to login
          await _secureStorage.delete(key: 'auth_token');
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      // If network fails or server is offline, fallback to login screen or handle gracefully
      if (mounted) {
        await _secureStorage.delete(key: 'auth_token');
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFBF7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated or Styled Logo Container
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF26B0F), Color(0xFFD9480F)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x59EA580C),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Smart Service Request',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'نظام طلبات الخدمات الجامعية الذكي',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 14,
                  color: Color(0xFF57534E),
                ),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: Color(0xFFF97316),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
