import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_screen.dart';

void main() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('Erro ao carregar .env: $e');
    return; // Sai do aplicativo se o .env não for encontrado
  }
  runApp(const VehicleControlApp());
}

class VehicleControlApp extends StatelessWidget {
  const VehicleControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Veículos',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6A00),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFFF6A00),
          secondary: const Color(0xFFFF8B3D),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF0B0B0B)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}