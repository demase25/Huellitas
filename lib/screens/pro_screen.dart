// lib/screens/pro_screen.dart

import 'package:flutter/material.dart';
import '../services/pro_service.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  bool _activating = false;

  Future<void> _activatePro() async {
    setState(() {
      _activating = true;
    });
    // Simulación de compra exitosa
    await ProService.setProEnabled(true);
    if (mounted) {
      setState(() {
        _activating = false;
      });
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _activating = true;
    });
    await ProService.restorePurchase();
    if (mounted) {
      setState(() {
        _activating = false;
      });
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        title: const Text('Pro Compra Única'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8A65)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                   const Row(
                     children: [
                       Icon(Icons.stars, color: Colors.white, size: 28),
                       SizedBox(width: 12),
                       Text(
                         'Huellitas Pro',
                         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                       ),
                     ],
                   ),
                   const SizedBox(height: 8),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.2),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: const Text(
                       'COMPRA ÚNICA',
                       style: TextStyle(
                         fontSize: 12,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                         letterSpacing: 1,
                       ),
                     ),
                   ),
                   const SizedBox(height: 16),
                   const Text(
                     'Desbloquea funciones premium para cuidar mejor a tus mascotas',
                     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                   ),
                 ],
              ),
            ),
            const SizedBox(height: 16),
            _buildFeature(
              Icons.pets, 
              'Mascotas ilimitadas', 
              'Agrega tantas mascotas como quieras (actualmente limitado a 2 en versión gratuita).',
              isHighlighted: true,
            ),
            const SizedBox(height: 12),
            _buildFeature(
              Icons.notifications_active, 
              'Recordatorios ilimitados', 
              'Crea recordatorios sin restricciones (actualmente limitado a 3 en versión gratuita).',
              isHighlighted: true,
            ),
            const SizedBox(height: 12),
            _buildFeature(
              Icons.block, 
              'Sin publicidad', 
              'Disfruta de una experiencia completamente limpia sin anuncios.',
            ),
            const SizedBox(height: 16),
            // Mensaje sobre funciones gratuitas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Las funciones básicas como exportar, importar y limpiar datos están disponibles gratuitamente para todos los usuarios.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Información de precio
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    ProService.getSloganLanzamiento(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ProService.getPrecioLanzamiento(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'por única vez',
                        style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Acceso de por vida • Sin suscripciones',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Botón de compra
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _activating ? null : _activatePro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: _activating
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Comprar Pro Compra Única',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: _activating ? null : _restore,
                child: const Text('Restaurar compras'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String subtitle, {bool isHighlighted = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFFF6B35).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted 
              ? const Color(0xFFFF6B35).withOpacity(0.4)
              : Colors.grey.withOpacity(0.25)
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlighted 
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon, 
              color: isHighlighted ? Colors.white : const Color(0xFFFF6B35),
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
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                    color: isHighlighted ? const Color(0xFFFF6B35) : const Color(0xFF2C3E50)
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: const TextStyle(fontSize: 14, color: Color(0xFF666666))
                ),
              ],
            ),
          ),
          if (isHighlighted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


