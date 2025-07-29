// lib/screens/recordatorio_form_screen.dart

import 'package:flutter/material.dart';
import '../models/mascota.dart';

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
  String _tipoRecordatorio = 'Vacuna';

  final List<String> _tiposRecordatorio = [
    'Vacuna',
    'Veterinaria',
    'Baño',
    'Corte de pelo',
    'Desparasitación',
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
    );
    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]}. ${date.year}';
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
      case 'Desparasitación':
        return Icons.medication;
      default:
        return Icons.event_note;
    }
  }

  void _saveRecordatorio() {
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

      final recordatorio = Recordatorio(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mascotaId: widget.mascota.id,
        titulo: _tituloController.text,
        fecha: _fecha!,
        descripcion: _descripcionController.text.isEmpty 
            ? null 
            : _descripcionController.text,
      );

      // Aquí guardarías en la base de datos
      // Por ahora solo navegamos de vuelta
      Navigator.pop(context, recordatorio);
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
                    
                    // Campo Fecha
                    _buildDateField(),
                    
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha del recordatorio',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
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
                    : Colors.transparent,
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
      ],
    );
  }
} 