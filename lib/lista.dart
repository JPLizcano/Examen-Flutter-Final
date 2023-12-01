// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_final/editar.dart';
import 'package:examen_final/eliminar.dart';
import 'package:examen_final/menu.dart';

class Listar extends StatefulWidget {
  const Listar({Key? key}) : super(key: key);

  @override
  State<Listar> createState() => _ListarState();
}

class _ListarState extends State<Listar> {
  double precioReparacion = 0.0;
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  var unidad = 'unidad';
  var valorDolar = 'valor';
  var desde = 'desde';
  var hasta = 'hasta';
  int horasReparacionesTotales = 0;
  int valorTotalReparacionescop = 0;
  double valorTotalReparacionesusd = 0.0;
  List<dynamic> dolar = [];
  List<dynamic> filteredDolar = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getVehiculo();
    getDolar();
  }

  Future<void> getVehiculo() async {
    const Center(child: CircularProgressIndicator());
    final response = await http
        .get(Uri.parse('https://api-vehiculos-ebht.onrender.com/api/vehiculo'));
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);
      setState(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Listando...'),
              backgroundColor: Color.fromARGB(255, 0, 100, 100),
              duration: Duration(milliseconds: 500),
            ),
          );
          data = decodedData['vehiculos'] ?? [];
          for (var i in data) {
            horasReparacionesTotales += int.parse(i['horasReparacion']);
            valorTotalReparacionescop += int.parse(i['precioReparacion']);
            valorTotalReparacionesusd +=
                int.parse(i['precioReparacion']) / double.parse(valorDolar);
          }
          filteredData.addAll(data);
        },
      );
    } else {
      setState(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al listar...'),
              backgroundColor: Color.fromARGB(255, 0, 100, 100),
              duration: Duration(seconds: 2),
            ),
          );
        },
      );
    }
  }

  Future<void> getDolar() async {
    final response = await http
        .get(Uri.parse('https://www.datos.gov.co/resource/32sa-8pi3.json'));
    if (response.statusCode == 200) {
      List decodedDolar = json.decode(response.body);
      setState(() {
        dolar = decodedDolar;
        filteredDolar.addAll(dolar);
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al listar...'),
            backgroundColor: Color.fromARGB(255, 0, 100, 100),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }

    for (var i in dolar) {
      valorDolar = i['valor'];
      break;
    }
  }

  void _filterList(String searchText) {
    setState(() {
      filteredData = data
          .where((user) =>
              user['numero'].toLowerCase().contains(searchText.toLowerCase()) ||
              user['placa'].toLowerCase().contains(searchText.toLowerCase()) ||
              user['horasReparacion']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              user['precioReparacion']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              user['observaciones']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  var vehiculoSel = "";

  void editar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Editar(vehiculoSel)));
  }

  void eliminar() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Eliminar(vehiculoSel)));
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
        title: const Center(child: Text('Lista de vehiculos')),
        backgroundColor: const Color.fromARGB(255, 0, 100, 100),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterList(value);
              },
              decoration: const InputDecoration(
                labelText: 'Buscar...',
                labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                floatingLabelStyle:
                    TextStyle(color: Color.fromARGB(255, 0, 100, 100)),
                prefixIcon:
                    Icon(Icons.search, color: Color.fromARGB(255, 0, 100, 100)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 0, 0, 0), width: 1)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 0, 100, 100))),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Card(
                    elevation: 10,
                    color: const Color.fromARGB(255, 220, 245, 245),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10, bottom: 5),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.numbers,
                                  color: Color.fromARGB(255, 0, 100, 100),
                                ),
                              ),
                              Text('Número: ' + filteredData[index]['numero']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.car_crash_rounded,
                                  color: Color.fromARGB(255, 0, 100, 100),
                                ),
                              ),
                              Text('Placa:  ' + filteredData[index]['placa']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.punch_clock,
                                  color: Color.fromARGB(255, 0, 100, 100),
                                ),
                              ),
                              Text('Horas de reparación:  ' +
                                  filteredData[index]['horasReparacion']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Color.fromARGB(255, 0, 100, 100),
                                ),
                              ),
                              Text('Precio de la reparación en pesos:  ' +
                                  filteredData[index]['precioReparacion'] +
                                  ' COP'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.monetization_on_outlined,
                                  color: Color.fromARGB(255, 0, 100, 100),
                                ),
                              ),
                              Text(
                                'Precio de la reparación en dólares: ' +
                                    (double.parse(filteredData[index]
                                                ['precioReparacion']) /
                                            double.parse(valorDolar))
                                        .toStringAsFixed(2),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.format_list_numbered,
                                  color: Color.fromARGB(255, 0, 100, 100),
                                ),
                              ),
                              Text('Observaciones:  ' +
                                  filteredData[index]['observaciones']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          vehiculoSel =
                                              filteredData[index]['placa'];
                                          editar();
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                            Color.fromARGB(255, 0, 100, 100),
                                          ),
                                        ),
                                        child: const Text('Modificar'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          vehiculoSel =
                                              filteredData[index]['placa'];
                                          eliminar();
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                            Color.fromARGB(255, 0, 100, 100),
                                          ),
                                        ),
                                        child: const Text('Eliminar'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 220, 245, 245),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Cantidad total de horas de reparaciones: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(horasReparacionesTotales.toString()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Text("Valor total de reparaciones en pesos: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("$valorTotalReparacionescop COP"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Text("Valor total de reparaciones en dólares: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(valorTotalReparacionesusd.toStringAsFixed(2) +
                              " USD"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
