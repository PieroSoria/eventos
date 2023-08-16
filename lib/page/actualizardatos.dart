import 'package:eventos/page/database.dart';
import 'package:flutter/material.dart';

class ResultadosInvitados extends StatefulWidget {
  final String id;
  final String codigo;
  final String documento;
  final String nombre;
  final String evento;
  final String zonas;
  final String ingreso;
  final String salida;
  const ResultadosInvitados(
      {super.key,
      required this.id,
      required this.codigo,
      required this.documento,
      required this.nombre,
      required this.evento,
      required this.zonas,
      required this.ingreso,
      required this.salida});

  @override
  State<ResultadosInvitados> createState() => _ResultadosInvitadosState();
}

class _ResultadosInvitadosState extends State<ResultadosInvitados> {
  TextEditingController codigocontroller = TextEditingController();
  TextEditingController documentoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController eventoController = TextEditingController();
  TextEditingController zonaController = TextEditingController();
  TextEditingController ingresoController = TextEditingController();
  TextEditingController salidaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    codigocontroller.text = widget.codigo;
    documentoController.text = widget.documento;
    nombreController.text = widget.nombre;
    eventoController.text = widget.evento;
    zonaController.text = widget.zonas;
    ingresoController.text = widget.ingreso;
    salidaController.text = widget.salida;
  }

  SQLdb funciones = SQLdb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('DATOS DEL USUARIO'),
        backgroundColor: const Color.fromARGB(255, 11, 98, 228),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: codigocontroller,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'codigo del invitado',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: documentoController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'documento del invitado',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nombreController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'nombre del evento',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: eventoController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'evento',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: zonaController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'zona',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ingresoController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'Ingreso',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: salidaController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 98, 228),
                ),
                decoration: InputDecoration(
                  labelText: 'Salida',
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
                  UPDATE resultados SET
                  codigo = "${codigocontroller.text}",
                  documento = "${documentoController.text}",
                  nombre = "${nombreController.text}",
                  evento = "${eventoController.text}",
                  zona = "${zonaController.text}",
                  ingreso = "${ingresoController.text}",
                  salida = "${salidaController.text}"
                  WHERE id = "${widget.id}"
                  ''');
                  if (rep > 0) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: currentContext,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'SE ACTUALIZO LOS DATOS DEL INVITADO',
                          style: TextStyle(
                            color: Color.fromARGB(255, 11, 98, 228),
                          ),
                        ),
                        content: const Text(
                          'PUEDE REVISARLO EN LA LISTA DE INVITADOS',
                          style: TextStyle(
                            color: Color.fromARGB(255, 11, 98, 228),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 98, 228),
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
