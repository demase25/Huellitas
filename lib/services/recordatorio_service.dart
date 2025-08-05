// lib/services/recordatorio_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mascota.dart';

class RecordatorioService {
  static const String _recordatoriosKey = 'recordatorios';

  // Guardar un recordatorio
  static Future<void> saveRecordatorio(Recordatorio recordatorio) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obtener recordatorios existentes
    List<Recordatorio> recordatorios = await getRecordatorios();
    
    // Agregar el nuevo recordatorio
    recordatorios.add(recordatorio);
    
    // Convertir a JSON y guardar
    List<String> recordatoriosJson = recordatorios
        .map((r) => jsonEncode(r.toMap()))
        .toList();
    
    await prefs.setStringList(_recordatoriosKey, recordatoriosJson);
  }

  // Obtener todos los recordatorios
  static Future<List<Recordatorio>> getRecordatorios() async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String>? recordatoriosJson = prefs.getStringList(_recordatoriosKey);
    
    if (recordatoriosJson == null) {
      return [];
    }
    
    return recordatoriosJson
        .map((json) => Recordatorio.fromMap(jsonDecode(json)))
        .toList();
  }

  // Obtener recordatorios de una mascota específica
  static Future<List<Recordatorio>> getRecordatoriosByMascotaId(String mascotaId) async {
    List<Recordatorio> todosLosRecordatorios = await getRecordatorios();
    
    return todosLosRecordatorios
        .where((recordatorio) => recordatorio.mascotaId == mascotaId)
        .toList();
  }

  // Eliminar un recordatorio
  static Future<void> deleteRecordatorio(String recordatorioId) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<Recordatorio> recordatorios = await getRecordatorios();
    
    recordatorios.removeWhere((r) => r.id == recordatorioId);
    
    List<String> recordatoriosJson = recordatorios
        .map((r) => jsonEncode(r.toMap()))
        .toList();
    
    await prefs.setStringList(_recordatoriosKey, recordatoriosJson);
  }

  // Actualizar un recordatorio
  static Future<void> updateRecordatorio(Recordatorio recordatorio) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<Recordatorio> recordatorios = await getRecordatorios();
    
    int index = recordatorios.indexWhere((r) => r.id == recordatorio.id);
    
    if (index != -1) {
      recordatorios[index] = recordatorio;
      
      List<String> recordatoriosJson = recordatorios
          .map((r) => jsonEncode(r.toMap()))
          .toList();
      
      await prefs.setStringList(_recordatoriosKey, recordatoriosJson);
    }
  }

  // Marcar recordatorio como completado
  static Future<void> toggleRecordatorioCompletado(String recordatorioId) async {
    List<Recordatorio> recordatorios = await getRecordatorios();
    
    int index = recordatorios.indexWhere((r) => r.id == recordatorioId);
    
    if (index != -1) {
      Recordatorio recordatorio = recordatorios[index];
      Recordatorio updatedRecordatorio = Recordatorio(
        id: recordatorio.id,
        mascotaId: recordatorio.mascotaId,
        titulo: recordatorio.titulo,
        fecha: recordatorio.fecha,
        descripcion: recordatorio.descripcion,
        completado: !recordatorio.completado,
      );
      
      await updateRecordatorio(updatedRecordatorio);
    }
  }

  // Obtener recordatorios próximos (próximos 7 días)
  static Future<List<Recordatorio>> getRecordatoriosProximos() async {
    List<Recordatorio> todosLosRecordatorios = await getRecordatorios();
    DateTime ahora = DateTime.now();
    DateTime proximaSemana = ahora.add(const Duration(days: 7));
    
    return todosLosRecordatorios
        .where((recordatorio) => 
            recordatorio.fecha.isAfter(ahora) && 
            recordatorio.fecha.isBefore(proximaSemana) &&
            !recordatorio.completado)
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }
} 