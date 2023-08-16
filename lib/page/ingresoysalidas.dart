import 'package:eventos/page/database.dart';
import 'package:eventos/page/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IngresoySalidas extends StatefulWidget {
  final Index widget;
  const IngresoySalidas({super.key, required this.widget});

  @override
  State<IngresoySalidas> createState() => _IngresoySalidasState();
}

class _IngresoySalidasState extends State<IngresoySalidas> {
  TextEditingController codigocontroller = TextEditingController();
  String? codigo1;
  String? documento1;
  String? nombre1;
  String? evento1;
  String? zona1;
  String? ingreso1;
  String? salida1;
  FocusNode _focusNode = FocusNode();
  bool _switchValue = false;
  String? buscarcodigo;
  SQLdb sqLdb = SQLdb();
  List<Map<String, dynamic>> resultados = [];
  bool productoEncontrado = false;
  late DateTime time;
  String? future;

  Future<String> buscarProducto(String codigoBarra) async {
    final funciones = SQLdb();
    if (_switchValue == false) {
      bool comprobacion = await funciones.datoactivo(codigoBarra);
      if (comprobacion == true) {
        const query = 'SELECT * FROM invitados WHERE codigo = ?';
        final result = await sqLdb.rawQuery(query, [codigoBarra]);
        final fin = await sqLdb.getNext();

        setState(() {
          resultados = result;
          productoEncontrado = resultados.isNotEmpty;

          if (productoEncontrado) {
            final resultado = resultados[0];
            codigo1 = resultado['codigo'];
            documento1 = resultado['documento'];
            nombre1 = resultado['nombre'];
            evento1 = resultado['evento'];
            zona1 = resultado['zona'];
          }
          time = DateTime.now();
          future = DateFormat('hh:mm:ss a').format(time);
        });
        final DateTime del = DateTime.now();
        final ingreso1 = DateFormat('hh:mm:ss a').format(del);
        const query2 = 'SELECT * FROM resultados WHERE codigo = ?';
        final result2 = await sqLdb.rawQuery(query2, [codigoBarra]);
        if (result2.isEmpty) {
          final dato = Resultados(
              id: fin,
              codigo: codigo1.toString(),
              documento: documento1.toString(),
              nombre: nombre1.toString(),
              evento: evento1.toString(),
              zona: zona1.toString(),
              ingreso: ingreso1,
              salidas: '');
          await funciones.insertarResultados(dato);
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('ADVERTENCIA'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'El invitado ya ingreso',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  BackButton(),
                ],
              );
            },
          );
        }

        return buscarcodigo = codigoBarra;
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('ADVERTENCIA'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'El usuario no se encuentra',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                BackButton(),
              ],
            );
          },
        );
      }
    } else {
      const query = 'SELECT * FROM invitados WHERE codigo = ?';
      final result = await sqLdb.rawQuery(query, [codigoBarra]);
      setState(() {
        resultados = result;
        productoEncontrado = resultados.isNotEmpty;

        if (productoEncontrado) {
          final resultado = resultados[0];
          codigo1 = resultado['codigo'];
          documento1 = resultado['documento'];
          nombre1 = resultado['nombre'];
          evento1 = resultado['evento'];
          zona1 = resultado['zona'];
        }
        time = DateTime.now();
        future = DateFormat('hh:mm:ss a').format(time);
      });
      final DateTime del = DateTime.now();
      final salida = DateFormat('hh:mm:ss a').format(del);
      const query3 = 'SELECT salida FROM resultados WHERE codigo = ?';
      final result3 = await sqLdb.rawQuery(query3, [codigoBarra]);
      if (result3.isEmpty || result3.first['salida'] == '') {
        await funciones.updateData(
            "UPDATE resultados SET salida = '$salida' WHERE codigo = '$codigo1'");
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('ADVERTENCIA'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'El Invitado ya salio del evento',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                BackButton(),
              ],
            );
          },
        );
      }

      return buscarcodigo = codigoBarra;
    }
    return buscarcodigo = codigoBarra;
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(widget.widget.user),
                Row(
                  children: [
                    const Text("Ingreso"),
                    Switch(
                        value: _switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _switchValue = value;
                            _focusNode = FocusNode();
                            _focusNode.requestFocus();
                          });
                        }),
                    const Text("Salidas")
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: codigocontroller,
              decoration: InputDecoration(
                  labelText: 'Ingrese codigo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onSubmitted: (value) {
                String value = codigocontroller.text;
                String codigoBarra = value;
                buscarProducto(codigoBarra);
                codigocontroller.text = '';
              },
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> resultado = resultados[index];
                  return ListBody(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Codigo: ${resultado['codigo']}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Documento: ${resultado['documento']}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Nombre: ${resultado['nombre']}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Evento: ${resultado['evento']}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Zona: ${resultado['zona']}"),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_switchValue == false)
                        Text(
                          "Hora de Ingreso: $future",
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        )
                      else
                        Text(
                          "Hora de Salida: $future",
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
