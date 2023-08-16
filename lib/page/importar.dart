import 'dart:io';

import 'package:eventos/page/database.dart';
import 'package:eventos/page/index.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Importar extends StatefulWidget {
  final Index widget;
  const Importar({super.key, required this.widget});

  @override
  State<Importar> createState() => _ImportarState();
}

class _ImportarState extends State<Importar> {
  File? _selectedFile;
  String _selectedFileName = '';
  TextEditingController selectalmacen = TextEditingController();
  TextEditingController selectalmacen2 = TextEditingController();
  List<String> dropdownItems = [];
  List<String> dropdownItems2 = [];
  SQLdb sqLdb = SQLdb();
  String? _selectedItem;
  String? _selectedItem2;
  final _tableNameController = TextEditingController();
  bool _isDisposed = false;
  bool _switchValue = false;
  TextEditingController codigocontroller = TextEditingController();
  TextEditingController documentocontroller = TextEditingController();
  TextEditingController nombrecontroller = TextEditingController();
  TextEditingController selecteventocontroller = TextEditingController();
  TextEditingController selectzonacontroller = TextEditingController();

  @override
  void initState() {
    initDropdownItems();
    initDropdownItems2();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tableNameController.dispose();
    super.dispose();
  }

  Future<void> initDropdownItems() async {
    dropdownItems = await sqLdb.captureData();
    setState(() {
      // Set the initial selected item
      if (dropdownItems.isNotEmpty) {
        _selectedItem = dropdownItems.first;
      }
    });
  }

  Future<void> initDropdownItems2() async {
    dropdownItems2 = await sqLdb.captureData2();
    setState(() {
      // Set the initial selected item
      if (dropdownItems2.isNotEmpty) {
        _selectedItem2 = dropdownItems2.first;
      }
    });
  }

  Future<void> insertarDatosDesdeExcel(String filePath, evento, zona) async {
    List<List<dynamic>> excelData = await leerExcel(filePath);
    if (!_isDisposed) {
      await insertarDatos(excelData, evento, zona);
    }
  }

  Future<List<List<dynamic>>> leerExcel(String filePath) async {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var sheet = excel.tables[excel.tables.keys.first];
    var rows = sheet!.rows;

    return rows;
  }

  Future<void> insertarDatos(List<List<dynamic>> data, evento, zona) async {
    final SQLdb sqLdb = SQLdb();
    final int maxRows = data.length;

    // Obtener la cantidad real de filas con datos no vacíos
    int numRowsWithData = 0;
    for (int i = 0; i < maxRows; i++) {
      var fila = data[i];
      if (fila.any((cell) =>
          cell != null &&
          cell.value != null &&
          cell.value.toString().isNotEmpty)) {
        numRowsWithData++;
      }
    }

    // Importar solo la cantidad de datos encontrados en el archivo de Excel
    for (int i = 1; i < numRowsWithData; i++) {
      var id = await sqLdb.getNext2();
      var codigo = data[i][0]?.value?.toString() ?? '';
      var documento = data[i][1]?.value?.toString() ?? '';
      var nombre = data[i][2]?.value?.toString() ?? '';
      var evento1 = evento;
      var zona1 = zona;

      // Verificar si el código ya existe en la tabla de invitados
      bool codigoExistente = await sqLdb.isCodigoExistente(codigo);
      if (codigoExistente) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ADVERTENCIA'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'El código ya existe en la tabla de invitados, revise la tabla de Excel.',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
        return; // Cancelar la operación
      }

      final invitados = Invitados1(
        id: id,
        codigo: codigo,
        documento: documento,
        nombre: nombre,
        evento: evento1,
        zona: zona1,
      );

      if (codigo.isNotEmpty || documento.isNotEmpty || nombre.isNotEmpty) {
        await sqLdb.insertinvitados(invitados);
        // ignore: use_build_context_synchronously
      }
    }
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MENSAJE'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Los datos fueron importados correctamente',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedFile = null;
                  _selectedFileName = '';
                });
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void guardarDatos(String evento, String zona) async {
    await insertarDatosDesdeExcel(_selectedFile!.path, evento, zona);
    _selectedFile = null;
  }

  Future<void> guardardatos(String codigo, String documento, String nombre,
      String evento, String zona) async {
    final double fin = await sqLdb.getNext2();
    final datos = Invitados1(
        id: fin,
        codigo: codigo,
        documento: documento,
        nombre: nombre,
        evento: evento,
        zona: zona);
    await sqLdb.insertinvitados(datos);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MENSAJE',
            style: TextStyle(color: Color.fromARGB(255, 17, 102, 230)),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'LOS DATOS DEL INVITADO SE GUARDO CORRECTAMENTE',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 38, 119, 240)),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                codigocontroller.text = '';
                documentocontroller.text = '';
                nombrecontroller.text = '';
                selecteventocontroller.text = '';
                selectzonacontroller.text = '';
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 18, 103, 231),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'ACEPTAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.widget.user,
                    style: const TextStyle(
                        fontSize: 25, color: Color.fromARGB(255, 60, 138, 240)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Importar Excel"),
                      Switch(
                          value: _switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              _switchValue = value;
                            });
                          }),
                      const Text("Manual")
                    ],
                  ),
                ],
              ),
              if (_switchValue == false) importar() else ingresar()
            ],
          ),
        ),
      ),
    );
  }

  Widget importar() {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedItem,
              items: dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Center(child: Text(item)),
                );
              }).toList(),
              onChanged: (String? selectedItem) {
                if (dropdownItems.contains(selectedItem)) {
                  setState(() {
                    _selectedItem = selectedItem!;
                    selectalmacen.text = _selectedItem.toString();
                  });
                }
              },
              style: const TextStyle(
                  color: Color.fromARGB(255, 48, 124, 238), fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedItem2,
              items: dropdownItems2.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Center(child: Text(item)),
                );
              }).toList(),
              onChanged: (String? selectedItem2) {
                if (dropdownItems2.contains(selectedItem2)) {
                  setState(() {
                    _selectedItem2 = selectedItem2!;
                    selectalmacen2.text = _selectedItem2.toString();
                  });
                }
              },
              style: const TextStyle(
                  color: Color.fromARGB(255, 48, 124, 238), fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _selectedFileName, // Mostrar el nombre del archivo seleccionado
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx', 'xls'],
                );
                if (result != null && result.files.isNotEmpty) {
                  _selectedFile = File(result.files.first.path!);
                  setState(() {
                    _selectedFileName = result.files.first.name;
                  });
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
                                'El documento no se cargó en la base de datos',
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
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 41, 122, 243),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(16.0),
              ),
              child: const SizedBox(
                width: 200,
                child: Text(
                  'BUSCAR EXCEL',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tableNameController.text = '';
                      _selectedFile = null;
                      _selectedFileName = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 182, 182, 182),
                    backgroundColor: const Color.fromARGB(255, 47, 125, 241),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: const SizedBox(
                    child: Text(
                      'CANCELAR',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectalmacen.text != "SELECCIONAR EVENTO" &&
                        selectalmacen2.text != "SELECCIONAR ZONA" &&
                        selectalmacen.text != "" &&
                        selectalmacen2.text != "") {
                      String evento = selectalmacen.text;
                      String zona = selectalmacen2.text;
                      guardarDatos(evento, zona);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('ADVERTENCIA'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text(
                                    'Seleccione un evento y zona',
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
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 182, 182, 182),
                    backgroundColor: const Color.fromARGB(255, 35, 117, 241),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: const SizedBox(
                    child: Text(
                      'GUARDAR',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget ingresar() {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Codigo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            controller: codigocontroller,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Documento',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            controller: documentocontroller,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Ingrese los nombres',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            controller: nombrecontroller,
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedItem,
            items: dropdownItems.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Center(child: Text(item)),
              );
            }).toList(),
            onChanged: (String? selectedItem) {
              if (dropdownItems.contains(selectedItem)) {
                setState(() {
                  _selectedItem = selectedItem!;
                  selecteventocontroller.text = _selectedItem.toString();
                });
              }
            },
            style: const TextStyle(
                color: Color.fromARGB(255, 11, 96, 224), fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedItem2,
            items: dropdownItems2.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Center(child: Text(item)),
              );
            }).toList(),
            onChanged: (String? selectedItem2) {
              if (dropdownItems2.contains(selectedItem2)) {
                setState(() {
                  _selectedItem2 = selectedItem2!;
                  selectzonacontroller.text = _selectedItem2.toString();
                });
              }
            },
            style: const TextStyle(
                color: Color.fromARGB(255, 29, 118, 252), fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              String cod = codigocontroller.text;
              String doc = documentocontroller.text;
              String nom = nombrecontroller.text;
              String event = selecteventocontroller.text;
              String zona = selectzonacontroller.text;
              guardardatos(cod, doc, nom, event, zona);
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: const SizedBox(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("GUARDAR"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
