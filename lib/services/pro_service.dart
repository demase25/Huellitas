// lib/services/pro_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class ProService {
  static const String _proKey = 'is_pro';
  static const int _maxFreeMascotas = 2;
  static const int _maxFreeRecordatorios = 3;

  static Future<bool> isPro() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_proKey) ?? false;
  }

  static Future<void> setProEnabled(bool enabled) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_proKey, enabled);
  }

  static Future<bool> restorePurchase() async {
    // Placeholder: en una implementación real, aquí llamarías al backend/Store
    // Por ahora, simulamos una restauración exitosa solo si ya estaba activo
    return await isPro();
  }

  // Verificar si puede agregar más mascotas
  static Future<bool> canAddMascota(int currentCount) async {
    if (await isPro()) return true;
    return currentCount < _maxFreeMascotas;
  }

  // Verificar si puede agregar más recordatorios
  static Future<bool> canAddRecordatorio(int currentCount) async {
    if (await isPro()) return true;
    return currentCount < _maxFreeRecordatorios;
  }

  // Obtener límites para mostrar en la UI
  static int getMaxFreeMascotas() => _maxFreeMascotas;
  static int getMaxFreeRecordatorios() => _maxFreeRecordatorios;
}


