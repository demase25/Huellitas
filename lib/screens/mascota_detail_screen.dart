// lib/screens/mascota_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/mascota.dart';
import '../services/recordatorio_service.dart';
import 'recordatorio_form_screen.dart';

class MascotaDetailScreen extends StatefulWidget {
  const MascotaDetailScreen({super.key});

  @override
  State<MascotaDetailScreen> createState() => _MascotaDetailScreenState();
}

class _MascotaDetailScreenState extends State<MascotaDetailScreen> {
  List<Recordatorio> _recordatorios = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecordatorios();
  }

  Future<void> _loadRecordatorios() async {
    final Mascota mascota = ModalRoute.of(context)!.settings.arguments as Mascota;
    try {
      final recordatorios = await RecordatorioService.getRecordatoriosByMascotaId(mascota.id);
      if (mounted) {
        setState(() {
          _recordatorios = recordatorios;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recordatorios = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Mascota mascota = ModalRoute.of(context)!.settings.arguments as Mascota;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        title: const Text('Detalles de Mascota'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono de perro y nombre
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Icono de perro
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 40,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nombre de la mascota
                  Text(
                    mascota.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información de la mascota
            Row(
              children: [
                // Tarjeta de fecha de nacimiento
                Expanded(
                  child: _buildInfoCard(
                    label: 'Nacimiento',
                    value: _formatDate(mascota.fechaNacimiento),
                    icon: Icons.cake,
                  ),
                ),
                const SizedBox(width: 12),
                // Tarjeta de raza
                Expanded(
                  child: _buildInfoCard(
                    label: 'Raza',
                    value: mascota.raza,
                    icon: Icons.pets,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tarjeta de observaciones
            _buildInfoCard(
              label: 'Observaciones',
              value: mascota.observaciones ?? 'Sin observaciones',
              icon: Icons.note,
              isFullWidth: true,
            ),
            
            const SizedBox(height: 32),
            
            // Sección de recordatorios
            const Text(
              'Recordatorios',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Mostrar recordatorios reales
            if (_recordatorios.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 48,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No hay recordatorios',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega tu primer recordatorio',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._recordatorios.map((recordatorio) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRecordatorioCard(recordatorio),
              )).toList(),
            
            const SizedBox(height: 16),
            
                                                  // Botón agregar recordatorio
              InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordatorioFormScreen(mascota: mascota),
                    ),
                  );
                                     if (result != null) {
                     // Recargar la lista de recordatorios
                     await _loadRecordatorios();
                   }
                },
               child: Container(
                 width: double.infinity,
                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(
                     color: const Color(0xFFFF6B35).withOpacity(0.3),
                     width: 1,
                   ),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(
                       Icons.add,
                       color: const Color(0xFFFF6B35),
                       size: 20,
                     ),
                     const SizedBox(width: 8),
                     Text(
                       'Agregar recordatorio',
                       style: TextStyle(
                         color: const Color(0xFFFF6B35),
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ],
                 ),
               ),
             ),
            
            const SizedBox(height: 32),
            
            // Botón editar mascota
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/mascota_form', arguments: mascota);
                },
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Editar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFFFF6B35),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard({
    required String title,
    required String date,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordatorioCard(Recordatorio recordatorio) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: recordatorio.completado 
            ? Colors.grey.withOpacity(0.1)
            : const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: recordatorio.completado 
              ? Colors.grey.withOpacity(0.3)
              : const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: recordatorio.completado 
                  ? Colors.grey
                  : const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForTipo(recordatorio.titulo),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recordatorio.titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: recordatorio.completado 
                        ? Colors.grey
                        : const Color(0xFF2C3E50),
                    decoration: recordatorio.completado 
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  _formatDateTime(recordatorio.fecha),
                  style: TextStyle(
                    fontSize: 14,
                    color: recordatorio.completado 
                        ? Colors.grey
                        : const Color(0xFF666666),
                  ),
                ),
                if (recordatorio.descripcion != null && recordatorio.descripcion!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      recordatorio.descripcion!,
                      style: TextStyle(
                        fontSize: 12,
                        color: recordatorio.completado 
                            ? Colors.grey.withOpacity(0.7)
                            : const Color(0xFF666666),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
                     // Botón para marcar como completado
           IconButton(
             onPressed: () async {
               await RecordatorioService.toggleRecordatorioCompletado(recordatorio.id);
               if (mounted) {
                 await _loadRecordatorios(); // Recargar la lista
               }
             },
             icon: Icon(
               recordatorio.completado 
                   ? Icons.check_circle
                   : Icons.radio_button_unchecked,
               color: recordatorio.completado 
                   ? const Color(0xFF4CAF50)
                   : Colors.grey,
             ),
           ),
        ],
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'Vacuna':
        return Icons.vaccines;
      case 'Veterinaria':
        return Icons.local_hospital;
      case 'Baño':
        return Icons.shower;
      case 'Corte de pelo':
        return Icons.content_cut;
      case 'Medicación':
        return Icons.medication;
      default:
        return Icons.event_note;
    }
  }

  String _formatDate(String date) {
    // Función simple para formatear la fecha
    // En una app real, usarías un paquete como intl
    try {
      final DateTime dateTime = DateTime.parse(date);
      final months = [
        'ene', 'feb', 'mar', 'abr', 'may', 'jun',
        'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]}. ${dateTime.year}';
    } catch (e) {
      return date; // Retorna la fecha original si no se puede parsear
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    
    String fechaStr = '${dateTime.day} ${months[dateTime.month - 1]}. ${dateTime.year}';
    
    // Si tiene hora específica (no es medianoche), agregar la hora
    if (dateTime.hour != 0 || dateTime.minute != 0) {
      fechaStr += ' a las ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    
    return fechaStr;
  }
}
