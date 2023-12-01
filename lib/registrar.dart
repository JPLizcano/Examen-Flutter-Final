// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_final/lista.dart';
import 'package:examen_final/menu.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  _RegistrarUsuario createState() => _RegistrarUsuario();
}

class _RegistrarUsuario extends State<Registrar> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController numero = TextEditingController();
  TextEditingController placa = TextEditingController();
  TextEditingController horasReparacion = TextEditingController();
  TextEditingController precioReparacion = TextEditingController();
  TextEditingController observaciones = TextEditingController();

  Future<void> _regVehiculo() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (numero.text.length > 10 && placa.text.length < 6 ||
          placa.text.length > 6 &&
              horasReparacion.text.length > 3 &&
              observaciones.text.length > 300) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con los datos ingresado.'),
              content: const Text('Revise los datos ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (numero.text.length > 10) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con la placa.'),
              content: const Text('Revise la placa ingresada.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (placa.text.length < 6 || placa.text.length > 6) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con la placa.'),
              content: const Text('Revise la placa ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (horasReparacion.text.length > 3) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con las horas de reparación.'),
              content: const Text('Revise las horas de reparación ingresadas.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (observaciones.text.length > 300) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con las observaciones.'),
              content: const Text('Revise las observaciones ingresadas.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        final url =
            Uri.parse('https://api-vehiculos-ebht.onrender.com/api/vehiculo');

        // Datos que quieres enviar al servidor
        final Map<String, dynamic> data = {
          "numero": numero.text,
          "placa": placa.text.toUpperCase(),
          "horasReparacion": horasReparacion.text,
          "precioReparacion": precioReparacion.text,
          "observaciones": observaciones.text,
        };

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrando...'),
              backgroundColor: Color.fromARGB(255, 0, 100, 100),
              duration: Duration(milliseconds: 500),
            ),
          );

          await Future.delayed(const Duration(seconds: 1));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Listar()));
          numero.clear();
          placa.clear();
          horasReparacion.clear();
          precioReparacion.clear();
          observaciones.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error al registrar. Código de error: ${response.statusCode}'),
              backgroundColor: const Color.fromARGB(255, 0, 100, 100),
              duration: const Duration(milliseconds: 500),
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
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Menu()));
          },
        ),
        title: const Center(child: Text('Registro de vehiculos')),
        backgroundColor: const Color.fromARGB(255, 0, 100, 100),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            color: const Color.fromARGB(255, 220, 245, 245),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: TextFormField(
                        controller: numero,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        decoration: InputDecoration(
                          labelText: 'Número',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 100, 100))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: const Icon(
                            Icons.numbers,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
                          helperText:
                              'El número debe ser entre 1 y 3 caracteres.',
                          counterText: '${numero.text.length}/3',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un número!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: TextFormField(
                        controller: placa,
                        keyboardType: TextInputType.text,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'Placa',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 100, 100))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: const Icon(
                            Icons.car_crash_rounded,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
                          helperText: 'El placa de debe ser de 6 caracteres.',
                          counterText: '${placa.text.length}/6',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese una placa!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: horasReparacion,
                        keyboardType: TextInputType.datetime,
                        maxLength: 3,
                        decoration: InputDecoration(
                          labelText: 'Horas de reparación',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 100, 100))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: const Icon(
                            Icons.punch_clock,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
                          helperText:
                              'Las horas de reparación deben ser ingresadas.',
                          counterText: '${horasReparacion.text.length}/3',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese las horas de reparación!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: precioReparacion,
                        keyboardType: TextInputType.text,
                        maxLength: 40,
                        decoration: InputDecoration(
                          labelText: 'precio de reparacion',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 100, 100))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: const Icon(
                            Icons.monetization_on,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
                          helperText:
                              'El precio de reparación debe ser de menos de 40 caracteres.',
                          counterText: '${precioReparacion.text.length}/40',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un precio de reparación!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: observaciones,
                        keyboardType: TextInputType.text,
                        maxLength: 300,
                        decoration: InputDecoration(
                          labelText: 'Observaciones',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 100, 100))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: const Icon(
                            Icons.format_list_numbered,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
                          helperText:
                              'La observación debe ser de menos de 300 caracteres.',
                          counterText: '${observaciones.text.length}/300',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese sus observaciones';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (observaciones.text.isEmpty) {
                                        observaciones.text =
                                            'Sin observaciones';
                                      }
                                      _regVehiculo();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 0, 100, 100))),
                                    child: const Text('Registrar vehiculo'),
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
                                          builder: (context) => const Menu(),
                                        ),
                                      );
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 0, 100, 100),
                                      ),
                                    ),
                                    child: const Text('Volver'),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
