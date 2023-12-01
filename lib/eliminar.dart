// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_final/lista.dart';

class Eliminar extends StatefulWidget {
  final String texto;
  const Eliminar(
    this.texto, {
    super.key,
  });

  @override
  State<Eliminar> createState() => _EditarState();
}

class _EditarState extends State<Eliminar> {
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  final _formKey = GlobalKey<FormState>();
  var placa = "";

  @override
  void initState() {
    super.initState();
    placa = widget.texto;
    getVehiculo();
  }

  Future<void> getVehiculo() async {
    const Center(child: CircularProgressIndicator());
    final response =
        await http.get(Uri.parse('https://api-vehiculos-ebht.onrender.com/api/vehiculo'));
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);
      setState(() {
        data = decodedData['usuarios'] ?? [];
        filteredData.addAll(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('cargando datos...')),
        );
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los datos...')),
        );
      });
    }
    // for (var i = 0; i < data.length; i++) {
    //   if (data[i]['placa'] == placa) {
    //     pl.text = data[i]['placa'];
    //     break;
    //   }
    // }
  }

  Future<void> _eliminarUsuario(String usu) async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> data = {'placa': placa};
      final response = await http.delete(
        Uri.parse('https://api-vehiculos-ebht.onrender.com/api/vehiculo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminando...')),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Listar()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al eliminar. Código de error: ${response.statusCode}...')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 220, 245, 245),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        '¿Seguro que desea eliminar el vehiculo con placa "$placa"?',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _eliminarUsuario(placa);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 0, 100, 100))),
                                    child: const Text('Eliminar vehiculo'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Listar()));
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 0, 100, 100))),
                                    child: const Text('Volver'),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
