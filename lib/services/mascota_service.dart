// lib/services/mascota_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mascota.dart';

class MascotaService {
  static const String _mascotasKey = 'mascotas';

  // Guardar una mascota
  static Future<void> saveMascota(Mascota mascota) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obtener mascotas existentes
    List<Mascota> mascotas = await getMascotas();
    
    // Verificar si la mascota ya existe (por ID)
    final existingIndex = mascotas.indexWhere((m) => m.id == mascota.id);
    if (existingIndex != -1) {
      // Actualizar mascota existente
      mascotas[existingIndex] = mascota;
    } else {
      // Agregar nueva mascota
      mascotas.add(mascota);
    }
    
    // Convertir a JSON y guardar
    List<String> mascotasJson = mascotas
        .map((m) => jsonEncode(m.toMap()))
        .toList();
    
    await prefs.setStringList(_mascotasKey, mascotasJson);
  }

  // Obtener todas las mascotas
  static Future<List<Mascota>> getMascotas() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? mascotasJson = prefs.getStringList(_mascotasKey);
    
    if (mascotasJson == null || mascotasJson.isEmpty) {
      return [];
    }
    
    return mascotasJson
        .map((json) => Mascota.fromMap(jsonDecode(json)))
        .toList();
  }

  // Obtener una mascota por ID
  static Future<Mascota?> getMascotaById(String id) async {
    final mascotas = await getMascotas();
    try {
      return mascotas.firstWhere((mascota) => mascota.id == id);
    } catch (e) {
      return null;
    }
  }

  // Eliminar una mascota
  static Future<void> deleteMascota(String id) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obtener mascotas existentes
    List<Mascota> mascotas = await getMascotas();
    
    // Filtrar la mascota a eliminar
    mascotas.removeWhere((mascota) => mascota.id == id);
    
    // Convertir a JSON y guardar
    List<String> mascotasJson = mascotas
        .map((m) => jsonEncode(m.toMap()))
        .toList();
    
    await prefs.setStringList(_mascotasKey, mascotasJson);
  }

  // Exportar datos como JSON
  static Future<String> exportData() async {
    final mascotas = await getMascotas();
    final data = {
      'mascotas': mascotas.map((m) => m.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
    
    return jsonEncode(data);
  }

  // Importar datos desde JSON
  static Future<void> importData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData);
      final List<dynamic> mascotasData = data['mascotas'] ?? [];
      
      final mascotas = mascotasData
          .map((mascotaData) => Mascota.fromMap(mascotaData))
          .toList();
      
      // Guardar todas las mascotas importadas
      final prefs = await SharedPreferences.getInstance();
      List<String> mascotasJson = mascotas
          .map((m) => jsonEncode(m.toMap()))
          .toList();
      
      await prefs.setStringList(_mascotasKey, mascotasJson);
    } catch (e) {
      throw Exception('Error al importar datos: $e');
    }
  }

  // Limpiar todos los datos
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mascotasKey);
  }
} 