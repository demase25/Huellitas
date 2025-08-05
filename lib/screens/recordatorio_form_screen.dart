// lib/screens/recordatorio_form_screen.dart

import 'package:flutter/material.dart';
import '../models/mascota.dart';
import '../services/recordatorio_service.dart';

class RecordatorioFormScreen extends StatefulWidget {
  final Mascota mascota;
  
  const RecordatorioFormScreen({
    super.key,
    required this.mascota,
  });

  @override
  State<RecordatorioFormScreen> createState() => _RecordatorioFormScreenState();
}

class _RecordatorioFormScreenState extends State<RecordatorioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  
  DateTime? _fecha;
  TimeOfDay? _hora;
  String _tipoRecordatorio = 'Vacuna';

  final List<String> _tiposRecordatorio = [
    'Vacuna',
    'Veterinaria',
    'Baño',
    'Corte de pelo',
    'Medicación',
    'Otro',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6B35),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2C3E50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6B35),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2C3E50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _hora) {
      setState(() {
        _hora = picked;
      });
    }
  }

  void _clearDateTime() {
    setState(() {
      _fecha = null;
      _hora = null;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    String fechaStr = '${date.day} ${months[date.month - 1]}. ${date.year}';
    
    // Si hay hora seleccionada, agregarla al formato de fecha
    if (_hora != null) {
      fechaStr += ' a las ${_formatTime(_hora)}';
    }
    
    return fechaStr;
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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

  Future<void> _saveRecordatorio() async {
    if (_formKey.currentState!.validate()) {
      if (_fecha == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una fecha'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Combinar fecha y hora si se seleccionó una hora
      DateTime fechaCompleta = _fecha!;
      if (_hora != null) {
        fechaCompleta = DateTime(
          _fecha!.year,
          _fecha!.month,
          _fecha!.day,
          _hora!.hour,
          _hora!.minute,
        );
      }

      final recordatorio = Recordatorio(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mascotaId: widget.mascota.id,
        titulo: _tituloController.text,
        fecha: fechaCompleta,
        descripcion: _descripcionController.text.isEmpty 
            ? null 
            : _descripcionController.text,
      );

      try {
        // Guardar el recordatorio usando el servicio
        await RecordatorioService.saveRecordatorio(recordatorio);
        
        // Mostrar mensaje de éxito
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recordatorio guardado exitosamente'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
        
        // Navegar de vuelta
        Navigator.pop(context, recordatorio);
      } catch (e) {
        // Mostrar mensaje de error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar el recordatorio: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        title: const Text('Agregar Recordatorio'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Panel principal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F0),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icono y título
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
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
                        Icons.event_note,
                        size: 40,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Nuevo recordatorio para ${widget.mascota.nombre}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Tipo de recordatorio
                    _buildDropdownField(),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Título
                    _buildFormField(
                      label: 'Título',
                      controller: _tituloController,
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El título es requerido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Fecha y Hora
                    _buildDateTimeField(),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Descripción
                    _buildFormField(
                      label: 'Descripción (opcional)',
                      controller: _descripcionController,
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botones de acción
                    Row(
                      children: [
                        // Botón Guardar
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveRecordatorio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Botón Cancelar
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: const Color(0xFF666666),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de recordatorio',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _tipoRecordatorio,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF6B35)),
              items: _tiposRecordatorio.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Row(
                    children: [
                      Icon(
                        _getIconForTipo(tipo),
                        color: const Color(0xFFFF6B35),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(tipo),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _tipoRecordatorio = newValue!;
                  _tituloController.text = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFFF6B35),
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha y hora del recordatorio',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        
        // Campo de fecha
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _fecha == null 
                    ? Colors.red.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: const Color(0xFFFF6B35),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _fecha == null 
                        ? 'Seleccionar fecha'
                        : _formatDate(_fecha),
                    style: TextStyle(
                      color: _fecha == null 
                          ? const Color(0xFF999999)
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                ),
                if (_fecha != null)
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF4CAF50),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Campo de hora
        InkWell(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hora == null 
                    ? Colors.orange.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: const Color(0xFFFF6B35),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _hora == null 
                        ? 'Seleccionar hora (opcional)'
                        : _formatTime(_hora),
                    style: TextStyle(
                      color: _hora == null 
                          ? const Color(0xFF999999)
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                ),
                if (_hora != null)
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF4CAF50),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        
        if (_fecha == null)
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 16),
            child: Text(
              'La fecha es requerida',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        
        // Botón para limpiar fecha y hora
        if (_fecha != null || _hora != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _clearDateTime,
                  icon: const Icon(
                    Icons.clear,
                    size: 16,
                    color: Color(0xFFFF6B35),
                  ),
                  label: const Text(
                    'Limpiar fecha y hora',
                    style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
} 