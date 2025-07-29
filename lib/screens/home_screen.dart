import 'package:flutter/material.dart';
import '../models/mascota.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista local simulada de mascotas
    final List<Mascota> mascotas = [
      Mascota(
        id: '1',
        nombre: 'Luna',
        raza: 'Golden Retriever',
        fechaNacimiento: '2020-06-12',
        peso: 25.5,
        imagen: 'assets/images/perro1.png',
      ),
      Mascota(
        id: '2',
        nombre: 'Milo',
        raza: 'Gato Siamés',
        fechaNacimiento: '2019-09-08',
        peso: 4.8,
        imagen: 'assets/images/gato1.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Huellitas 🐾'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: mascotas.length,
          itemBuilder: (context, index) {
            final mascota = mascotas[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Colors.pink.shade50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: mascota.imagen != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(mascota.imagen!),
                        radius: 30,
                      )
                    : const Icon(Icons.pets, size: 32),
                title: Text(
                  mascota.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('${mascota.raza} • ${mascota.fechaNacimiento}'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
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
        onPressed: () {
          Navigator.pushNamed(context, '/mascota_form');
        },
        backgroundColor: Colors.pinkAccent.shade100,
        child: const Icon(Icons.add),
      ),
    );
  }
}
