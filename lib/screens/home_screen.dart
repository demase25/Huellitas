import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/mascota.dart';
import '../services/mascota_service.dart';
import '../services/pro_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Mascota> _mascotas = [];
  bool _isLoading = true;
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _loadMascotas();
    _loadProStatus();
  }

  Future<void> _loadMascotas() async {
    try {
      final mascotas = await MascotaService.getMascotas();
      if (mounted) {
        setState(() {
          _mascotas = mascotas;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _mascotas = [];
          _isLoading = false;
        });
      }
    }
  }



  Future<void> _loadProStatus() async {
    final bool pro = await ProService.isPro();
    if (mounted) {
      setState(() {
        _isPro = pro;
      });
    }
  }



  void _showProUpsell(String feature) {
    String message = '';
    switch (feature) {
      case 'mascotas':
        message = 'Has alcanzado el límite de ${ProService.getMaxFreeMascotas()} mascotas en la versión gratuita.';
        break;
      case 'recordatorios':
        message = 'Has alcanzado el límite de ${ProService.getMaxFreeRecordatorios()} recordatorios en la versión gratuita.';
        break;
      default:
        message = 'Esta función requiere Pro Compra Única.';
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Función Pro'),
        content: Text('$message\n\n¿Quieres desbloquear Pro Compra Única para acceder a funciones ilimitadas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Más tarde'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/pro');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ver Pro'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMascota(Mascota mascota) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar mascota'),
        content: Text('¿Estás seguro de que quieres eliminar a ${mascota.nombre}? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await MascotaService.deleteMascota(mascota.id);
        await _loadMascotas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${mascota.nombre} ha sido eliminado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al eliminar la mascota'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _exportData() async {
    try {
      final data = await MascotaService.exportData();
      
      // Crear un archivo temporal con los datos
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'huellitas_backup_$timestamp.json';
      
      // Compartir usando el menú nativo
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(data.codeUnits),
            name: fileName,
            mimeType: 'application/json',
          ),
        ],
        text: 'Respaldo de datos de Huellitas - ${DateTime.now().toString().split('.')[0]}',
        subject: 'Respaldo Huellitas',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compartiendo datos de respaldo...'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al exportar los datos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        await MascotaService.importData(clipboardData!.text!);
        await _loadMascotas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Datos importados correctamente'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No hay datos en el portapapeles'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al importar los datos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareMascota(Mascota mascota) async {
    try {
      // Crear datos de la mascota en formato JSON
      final mascotaData = {
        'mascota': mascota.toMap(),
        'exportDate': DateTime.now().toIso8601String(),
        'app': 'Huellitas',
        'version': '1.0',
      };
      
      final data = jsonEncode(mascotaData);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${mascota.nombre}_${timestamp}.json';
      
      // Compartir usando el menú nativo
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(data.codeUnits),
            name: fileName,
            mimeType: 'application/json',
          ),
        ],
        text: 'Datos de ${mascota.nombre} - ${mascota.raza}',
        subject: 'Mascota: ${mascota.nombre}',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Compartiendo datos de ${mascota.nombre}...'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al compartir la mascota'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar todos los datos'),
        content: const Text('¿Estás seguro de que quieres eliminar todas las mascotas y recordatorios? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await MascotaService.clearAllData();
        await _loadMascotas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Todos los datos han sido eliminados'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al limpiar los datos'),
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
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Huellitas 🐾'),
            if (!_isPro && _mascotas.isNotEmpty)
              Text(
                '${_mascotas.length}/${ProService.getMaxFreeMascotas()} mascotas',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: _isPro ? 'Pro Compra Única activado' : 'Activar Pro Compra Única',
            icon: Icon(
              Icons.stars,
              color: _isPro ? Colors.yellowAccent : Colors.white,
            ),
            onPressed: () async {
              await Navigator.pushNamed(context, '/pro');
              await _loadProStatus();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'export':
                  await _exportData();
                  break;
                case 'import':
                  await _importData();
                  break;
                case 'clear':
                  await _clearAllData();
                  break;
                case 'pro':
                  await Navigator.pushNamed(context, '/pro');
                  await _loadProStatus();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Color(0xFFFF6B35)),
                    SizedBox(width: 8),
                    Text('Compartir datos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.file_upload, color: Color(0xFFFF6B35)),
                    SizedBox(width: 8),
                    Text('Importar datos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Limpiar todos los datos', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pro',
                child: Row(
                  children: [
                    Icon(Icons.stars, color: Color(0xFFFF6B35)),
                    SizedBox(width: 8),
                    Text('Pro Compra Única'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B35),
              ),
            )
          : _mascotas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 80,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay mascotas registradas',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isPro 
                            ? 'Agrega tu primera mascota'
                            : 'Agrega hasta ${ProService.getMaxFreeMascotas()} mascotas (versión gratuita)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      if (!_isPro) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/pro'),
                          child: const Text(
                            'Desbloquear ilimitado con Pro',
                            style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: _mascotas.length,
                    itemBuilder: (context, index) {
                      final mascota = _mascotas[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: mascota.imagen != null
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(mascota.imagen!),
                                  radius: 30,
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.pets,
                                    size: 32,
                                    color: Color(0xFFFF6B35),
                                  ),
                                ),
                          title: Text(
                            mascota.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text('${mascota.raza} • ${mascota.fechaNacimiento}'),
                                                     trailing: PopupMenuButton<String>(
                             icon: const Icon(Icons.more_vert),
                             onSelected: (value) async {
                               switch (value) {
                                 case 'edit':
                                   Navigator.pushNamed(
                                     context,
                                     '/mascota_form',
                                     arguments: mascota,
                                   );
                                   break;
                                 case 'share':
                                   await _shareMascota(mascota);
                                   break;
                                 case 'delete':
                                   await _deleteMascota(mascota);
                                   break;
                               }
                             },
                             itemBuilder: (context) => [
                               const PopupMenuItem(
                                 value: 'edit',
                                 child: Row(
                                   children: [
                                     Icon(Icons.edit, color: Color(0xFFFF6B35)),
                                     SizedBox(width: 8),
                                     Text('Editar'),
                                   ],
                                 ),
                               ),
                               const PopupMenuItem(
                                 value: 'share',
                                 child: Row(
                                   children: [
                                     Icon(Icons.share, color: Color(0xFFFF6B35)),
                                     SizedBox(width: 8),
                                     Text('Compartir'),
                                   ],
                                 ),
                               ),
                               const PopupMenuItem(
                                 value: 'delete',
                                 child: Row(
                                   children: [
                                     Icon(Icons.delete, color: Colors.red),
                                     SizedBox(width: 8),
                                     Text('Eliminar', style: TextStyle(color: Colors.red)),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/mascota_detail',
                              arguments: mascota,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Verificar límite de mascotas en modo free
          if (!_isPro && _mascotas.length >= ProService.getMaxFreeMascotas()) {
            _showProUpsell('mascotas');
            return;
          }
          
          final result = await Navigator.pushNamed(context, '/mascota_form');
          if (result != null) {
            await _loadMascotas();
          }
        },
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
