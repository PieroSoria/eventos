import 'package:flutter/material.dart';
import 'package:eventos/page/database.dart';


class Actualizar extends StatefulWidget {
  final String id;
  final String nombre;
  const Actualizar(
      {super.key,
      required this.id,
      required this.nombre});

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  TextEditingController nombreController = TextEditingController();
  

  SQLdb funciones = SQLdb();
  @override
  void initState() {
    nombreController.text = widget.nombre;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('EDITAR EVENTO'),
        backgroundColor: const Color.fromARGB(255, 11, 98, 228),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nombreController,
                style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 11, 98, 228),),
                decoration: InputDecoration(
                  labelText: 'nombre del evento',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final currentContext = context;
                  int rep = await funciones.updateData('''
                  UPDATE eventos SET
                  nombre = "${nombreController.text}"
                  WHERE id = "${widget.id}"
                  ''');
                  if (rep > 0) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: currentContext,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'SE ACTUALIZO EL EVENTO',
                          style: TextStyle(color: Color.fromARGB(255, 11, 98, 228),),
                        ),
                        content: const Text(
                          'PUEDE REVISARLO EN LA LISTA DE EVENTOS',
                          style: TextStyle(color: Color.fromARGB(255, 11, 98, 228),),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, '/index', (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromARGB(255, 11, 98, 228),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: const Text(
                                'ACEPTAR',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 11, 98, 228),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const SizedBox(
                  width: 270,
                  child: Text(
                    'GUARDAR CAMBIOS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 11, 98, 228),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const SizedBox(
                  width: 270,
                  child: Text(
                    'CANCELAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
