// lib/screens/mascota_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/mascota.dart';
import 'recordatorio_form_screen.dart';

class MascotaDetailScreen extends StatelessWidget {
  const MascotaDetailScreen({super.key});

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
            
            // Recordatorios de ejemplo (en una app real vendrían de una base de datos)
            _buildReminderCard(
              title: 'Vacuna',
              date: '20 abr. 2024',
              icon: Icons.vaccines,
            ),
            
            const SizedBox(height: 12),
            
            _buildReminderCard(
              title: 'Veterinaria',
              date: '5 may. 2024',
              icon: Icons.local_hospital,
            ),
            
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
                   // Aquí podrías actualizar la lista de recordatorios
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text('Recordatorio agregado exitosamente'),
                       backgroundColor: Color(0xFF4CAF50),
                     ),
                   );
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
}
