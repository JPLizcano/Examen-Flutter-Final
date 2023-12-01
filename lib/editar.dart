// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_final/lista.dart';

class Editar extends StatefulWidget {
  final String texto;
  const Editar(
    this.texto, {
    super.key,
  });

  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController numero = TextEditingController();
  TextEditingController placa = TextEditingController();
  TextEditingController horasReparacion = TextEditingController();
  TextEditingController precioReparacion = TextEditingController();
  TextEditingController observaciones = TextEditingController();

  @override
  void initState() {
    super.initState();
    placa.text = widget.texto;
    getUsuarios();
  }

  Future<void> getUsuarios() async {
    const Center(child: CircularProgressIndicator());
    final response = await http
        .get(Uri.parse('https://api-vehiculos-ebht.onrender.com/api/vehiculo'));
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);
      setState(() {
        data = decodedData['vehiculos'] ?? [];
        filteredData.addAll(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cargando...'),
            backgroundColor: Color.fromARGB(255, 0, 100, 100),
            duration: Duration(seconds: 1),
          ),
        );
      });

      for (var i = 0; i < data.length; i++) {
        if (data[i]['placa'] == placa.text) {
          numero.text = data[i]['numero'];
          horasReparacion.text = data[i]['horasReparacion'];
          precioReparacion.text = data[i]['precioReparacion'];
          observaciones.text = data[i]['observaciones'];
          break;
        }
      }
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar los datos...'),
            backgroundColor: Color.fromARGB(255, 0, 100, 100),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  Future<void> _modVehiculo(
      String pl, String num, String hr, String pr, String obs) async {
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
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        final Map<String, dynamic> data = {
          "placa": placa.text,
          "numero": num,
          "horasReparacion": hr,
          "precioReparacion": pr,
          "observaciones": obs,
        };

        final response = await http.put(
          Uri.parse('https://api-vehiculos-ebht.onrender.com/api/vehiculo'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modificando...'),
            backgroundColor: Color.fromARGB(255, 0, 100, 100),
            duration: Duration(milliseconds: 500),
          ),
        );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Listar()));
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al modificar...'),
            backgroundColor: Color.fromARGB(255, 0, 100, 100),
            duration: Duration(seconds: 2),
          ),
        );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Número',
                          border: InputBorder.none,
                          floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: Icon(
                            Icons.numbers,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
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
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Placa',
                          border: InputBorder.none,
                          floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 100, 100)),
                          icon: Icon(
                            Icons.car_crash_rounded,
                            color: Color.fromARGB(255, 0, 100, 100),
                          ),
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
                            return 'Ingrese sus observaciones!';
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
                                    onPressed: () async {
                                      if (observaciones.text.isEmpty) {
                                        observaciones.text =
                                            'Sin observaciones';
                                      }
                                      _modVehiculo(
                                          placa.text,
                                          numero.text,
                                          horasReparacion.text,
                                          precioReparacion.text,
                                          observaciones.text);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 0, 100, 100))),
                                    child: const Text('Modificar vehiculo'),
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
                                          builder: (context) => const Listar(),
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
