import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE8D6), // Naranja pastel muy claro
              Color(0xFFFFF3E9), // Naranja pastel claro
              Color(0xFFFFF8F0), // Naranja pastel extra claro
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                             // Huella grande y proporcional (como en home screen vacío)
               Container(
                 padding: const EdgeInsets.all(40),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: const Color(0xFFFF6B35).withOpacity(0.15), // Naranja pastel suave
                   boxShadow: [
                     BoxShadow(
                       color: const Color(0xFFFF6B35).withOpacity(0.2),
                       blurRadius: 40,
                       offset: const Offset(0, 20),
                     ),
                   ],
                 ),
                 child: const Icon(
                   Icons.pets,
                   size: 120, // Más grande que el home screen (80px)
                   color: Color(0xFFFF6B35), // Naranja principal suave
                 ),
               ),
              const SizedBox(height: 40),
                                                           // Título de la aplicación
                Text(
                  'Huellitas',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE64A19), // Naranja oscuro suave
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 15),
                                                           // Subtítulo
                Text(
                  'Cuidando a tus mascotas',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF666666), // Gris suave
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
