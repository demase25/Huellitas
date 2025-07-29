// lib/models/mascota.dart

class Mascota {
  final String id;
  final String nombre;
  final String raza;
  final String fechaNacimiento;
  final double peso;
  final String? observaciones;
  final String? imagen;

  Mascota({
    required this.id,
    required this.nombre,
    required this.raza,
    required this.fechaNacimiento,
    required this.peso,
    this.observaciones,
    this.imagen,
  });
}

class Recordatorio {
  final String id;
  final String mascotaId;
  final String titulo;
  final DateTime fecha;
  final String? descripcion;
  final bool completado;

  Recordatorio({
    required this.id,
    required this.mascotaId,
    required this.titulo,
    required this.fecha,
    this.descripcion,
    this.completado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mascotaId': mascotaId,
      'titulo': titulo,
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'completado': completado,
    };
  }

  factory Recordatorio.fromMap(Map<String, dynamic> map) {
    return Recordatorio(
      id: map['id'],
      mascotaId: map['mascotaId'],
      titulo: map['titulo'],
      fecha: DateTime.parse(map['fecha']),
      descripcion: map['descripcion'],
      completado: map['completado'] ?? false,
    );
  }
}
