// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mascota_detail_screen.dart';
import 'screens/mascota_form_screen.dart';
import 'screens/recordatorio_form_screen.dart';
import 'utils/theme.dart';
import 'package:huellitas/models/mascota.dart';

void main() {
  runApp(const HuellitasApp());
}

class HuellitasApp extends StatelessWidget {
  const HuellitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huellitas',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/mascota_form': (context) => const MascotaFormScreen(),
        '/mascota_detail': (context) => const MascotaDetailScreen(),
        '/recordatorio_form': (context) {
  final mascota = ModalRoute.of(context)!.settings.arguments as Mascota;
  return RecordatorioFormScreen(mascota: mascota);
},
      },
    );
  }
}
