import 'package:examen_final/lista.dart';
import 'package:examen_final/registrar.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Menú')
        ),
        backgroundColor: const Color.fromARGB(255, 0, 100, 100),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 220, 245, 245),
              child: ListTile(
                leading: const Icon(Icons.car_crash,
                    color: Color.fromARGB(255, 0, 100, 100)),
                title: const Text('Lista de vehiculos'),
                onTap: () {
                  final route = MaterialPageRoute(
                      builder: (context) => const Listar());
                  Navigator.push(context, route);
                },
              ),
            ),
          ),
          Card(
            elevation: 10,
            color: const Color.fromARGB(255, 220, 245, 245),
            child: ListTile(
              leading: const Icon(Icons.car_rental,
                  color: Color.fromARGB(255, 0, 100, 100)),
              title: const Text('Registrar vehiculo'),
              onTap: () {
                final route = MaterialPageRoute(
                    builder: (context) => const Registrar());
                Navigator.push(context, route);
              },
              // trailing: Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 255, 50, 0)),
            ),
          ),
        ],
      ),
    );
  }
}
