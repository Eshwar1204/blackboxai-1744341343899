import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/behavioral_screen.dart';
import 'screens/threat_screen.dart';
import 'screens/encryption_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Sentinel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1A237E), // Deep Blue
        secondaryHeaderColor: const Color(0xFF00BCD4), // Cyan
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          secondary: const Color(0xFF00BCD4),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/behavioral': (context) => const BehavioralScreen(),
        '/threat': (context) => const ThreatScreen(),
        '/encryption': (context) => const EncryptionScreen(),
      },
    );
  }
}
