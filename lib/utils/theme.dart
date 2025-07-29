import 'package:flutter/material.dart';

// Tema personalizado para la aplicación Huellitas
final ThemeData appTheme = ThemeData(
  // Colores principales
  primarySwatch: Colors.orange,
  primaryColor: const Color(0xFFFF6B35), // Naranja cálido
  primaryColorLight: const Color(0xFFFF8A65),
  primaryColorDark: const Color(0xFFE64A19),
  
  // Color de acento
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF6B35),
    secondary: const Color(0xFF4CAF50), // Verde para elementos secundarios
  ),
  
  // Configuración de AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFF6B35),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  
  // Configuración de botones
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF6B35),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // Configuración de FloatingActionButton
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFF6B35),
    foregroundColor: Colors.white,
  ),
  
  // Configuración de Card
  cardTheme: const CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  
  // Configuración de InputDecoration
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFFFF6B35)),
  ),
  
  // Configuración de texto
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2C3E50),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFF2C3E50),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFF2C3E50),
    ),
  ),
  
  // Configuración general
  useMaterial3: true,
  brightness: Brightness.light,
);
