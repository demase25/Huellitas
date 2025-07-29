// lib/screens/mascota_form_screen.dart

import 'package:flutter/material.dart';
import '../models/mascota.dart';

class MascotaFormScreen extends StatefulWidget {
  const MascotaFormScreen({super.key});

  @override
  State<MascotaFormScreen> createState() => _MascotaFormScreenState();
}

class _MascotaFormScreenState extends State<MascotaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _razaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _observacionesController = TextEditingController();
  
  DateTime? _fechaNacimiento;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMascotaData();
    });
  }

  void _loadMascotaData() {
    final Mascota? mascota = ModalRoute.of(context)?.settings.arguments as Mascota?;
    if (mascota != null) {
      setState(() {
        _isEditing = true;
        _nombreController.text = mascota.nombre;
        _razaController.text = mascota.raza;
        _pesoController.text = mascota.peso.toString();
        _observacionesController.text = mascota.observaciones ?? '';
        _fechaNacimiento = DateTime.tryParse(mascota.fechaNacimiento);
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _razaController.dispose();
    _pesoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
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

  void _saveMascota() {
    if (_formKey.currentState!.validate()) {
      if (_fechaNacimiento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una fecha de nacimiento'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final mascota = Mascota(
        id: _isEditing ? (ModalRoute.of(context)?.settings.arguments as Mascota).id : DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        raza: _razaController.text,
        fechaNacimiento: _fechaNacimiento!.toIso8601String(),
        peso: double.tryParse(_pesoController.text) ?? 0.0,
        observaciones: _observacionesController.text.isEmpty ? null : _observacionesController.text,
      );

      // Aquí guardarías en la base de datos
      // Por ahora solo navegamos de vuelta
      Navigator.pop(context, mascota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Mascota' : 'Agregar Mascota'),
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
              // Panel principal con fondo beige
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
                    // Icono de perro
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E9),
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
                    
                    // Título
                    Text(
                      _isEditing ? 'Editar mascota' : 'Agregar mascota',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Campo Nombre
                    _buildFormField(
                      label: 'Nombre',
                      controller: _nombreController,
                      icon: Icons.pets,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Fecha de nacimiento
                    _buildDateField(),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Raza
                    _buildFormField(
                      label: 'Raza',
                      controller: _razaController,
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La raza es requerida';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Peso
                    _buildFormField(
                      label: 'Peso',
                      controller: _pesoController,
                      icon: Icons.monitor_weight,
                      keyboardType: TextInputType.number,
                      suffixText: 'kg',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El peso es requerido';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingresa un peso válido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Campo Observaciones
                    _buildFormField(
                      label: 'Observaciones',
                      controller: _observacionesController,
                      icon: Icons.note,
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botones de acción
                    Row(
                      children: [
                        // Botón Guardar
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveMascota,
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? suffixText,
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
            suffixText: suffixText,
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
          'Fecha de nacimiento',
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
                color: _fechaNacimiento == null 
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
                    _fechaNacimiento == null 
                        ? 'Seleccionar fecha'
                        : _formatDate(_fechaNacimiento),
                    style: TextStyle(
                      color: _fechaNacimiento == null 
                          ? const Color(0xFF999999)
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_fechaNacimiento == null)
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 16),
            child: Text(
              'La fecha de nacimiento es requerida',
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
