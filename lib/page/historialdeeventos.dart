import 'dart:io';

import 'package:eventos/page/actualizardatos.dart';
import 'package:eventos/page/database.dart';
import 'package:eventos/page/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:excel/excel.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Historial extends StatefulWidget {
  final Index widget;
  const Historial({super.key, required this.widget});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  TextEditingController selectalmacen = TextEditingController();
  String? _selectedItem;
  List<String> dropdownItems = [];
  SQLdb sqLdb = SQLdb();
  TextEditingController searchController = TextEditingController();
  TextEditingController nameexcel = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    initDropdownItems();
    super.initState();
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

  Future<void> convertTableToExcel(String name, String filtro) async {
    // Abrir la base de datos SQLite
    final databasePath = await getDatabasesPath();
    final database =
        await openDatabase(path.join(databasePath, 'productos.db'));

    // Leer los datos de la tabla SQLite
    if (filtro != "SELECCIONAR EVENTO") {
      final List<Map<String, dynamic>> tableData = await database
          .query('resultados', where: 'evento = ?', whereArgs: [filtro]);
      final excel = Excel.createExcel();

      // Crear una hoja de trabajo en el archivo de Excel
      final sheet = excel['Sheet1'];

      // Escribir los encabezados de columna en la hoja de trabajo
      final headers = tableData.first.keys.toList();
      for (var i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }

      // Escribir los datos en la hoja de trabajo
      for (var i = 0; i < tableData.length; i++) {
        final row = tableData[i];
        final values = row.values.toList();
        for (var j = 0; j < values.length; j++) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
              .value = values[j].toString();
        }
      }

      // Mostrar el diálogo de selección de carpeta
      final outputPath = await FilePicker.platform.getDirectoryPath();

      if (outputPath != null) {
        // Obtener el directorio de documentos del dispositivo
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final documentsPath = documentsDirectory.path;

        // Crear la ruta de salida en la carpeta seleccionada
        final outputDirectory =
            Directory(path.join(documentsPath, 'ExcelOutput'));
        await outputDirectory.create(recursive: true);
        final excelPath = path.join(outputPath, '$name.xlsx');

        // Guardar el archivo de Excel en la carpeta seleccionada
        final excelBytes = excel.encode();
        final excelFile = File(excelPath);
        await excelFile.writeAsBytes(excelBytes!);
        debugPrint('Tabla SQLite convertida a Excel: $excelPath');
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'MENSAJE',
              style: TextStyle(color: Color.fromARGB(255, 42, 125, 250)),
            ),
            content: const Text(
              'SE GUARDO EXITOSAMENTE',
              style: TextStyle(color: Color.fromARGB(255, 55, 131, 245)),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  nameexcel.text = '';
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 44, 126, 248),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'ACEPTAR',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        debugPrint('No se seleccionó ninguna carpeta.');
      }
    } else {
      final List<Map<String, dynamic>> tableData =
          await database.query('resultados');
      final excel = Excel.createExcel();

      // Crear una hoja de trabajo en el archivo de Excel
      final sheet = excel['Sheet1'];

      // Escribir los encabezados de columna en la hoja de trabajo
      final headers = tableData.first.keys.toList();
      for (var i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }

      // Escribir los datos en la hoja de trabajo
      for (var i = 0; i < tableData.length; i++) {
        final row = tableData[i];
        final values = row.values.toList();
        for (var j = 0; j < values.length; j++) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
              .value = values[j].toString();
        }
      }

      // Mostrar el diálogo de selección de carpeta
      final outputPath = await FilePicker.platform.getDirectoryPath();

      if (outputPath != null) {
        // Obtener el directorio de documentos del dispositivo
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final documentsPath = documentsDirectory.path;

        // Crear la ruta de salida en la carpeta seleccionada
        final outputDirectory =
            Directory(path.join(documentsPath, 'ExcelOutput'));
        await outputDirectory.create(recursive: true);
        final excelPath = path.join(outputPath, '$name.xlsx');

        // Guardar el archivo de Excel en la carpeta seleccionada
        final excelBytes = excel.encode();
        final excelFile = File(excelPath);
        await excelFile.writeAsBytes(excelBytes!);
        debugPrint('Tabla SQLite convertida a Excel: $excelPath');
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'MENSAJE',
              style: TextStyle(color: Colors.blue.shade900),
            ),
            content: Text(
              'SE GUARDO EXITOSAMENTE',
              style: TextStyle(color: Colors.blue.shade900),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  nameexcel.text = '';
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 17, 105, 236),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'ACEPTAR',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        debugPrint('No se seleccionó ninguna carpeta.');
      }
    }

    // Crear un nuevo archivo de Excel
  }

  Future<List<Map>> getAllProducts({String? selectalmacen}) async {
    String query = "SELECT * FROM 'resultados'";
    if (selectalmacen != null &&
        selectalmacen.isNotEmpty &&
        selectalmacen != "SELECCIONAR EVENTO") {
      query += " WHERE evento LIKE '%$selectalmacen%'";
    } else {
      query;
    }
    List<Map> products = await sqLdb.getData(query);
    return products;
  }

  Future<void> refreshdata() async {
    setState(() {
      getAllProducts(selectalmacen: _selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: refreshdata,
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                Row(
                  children: [
                    Text(
                      widget.widget.user,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 35, 117, 240)),
                    ),
                  ],
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
                        selectalmacen.text = _selectedItem.toString();
                        getAllProducts(selectalmacen: selectedItem);
                      });
                    }
                  },
                  style: const TextStyle(
                      color: Color.fromARGB(255, 18, 105, 235), fontSize: 18),
                ),
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: FutureBuilder(
                        future:
                            getAllProducts(selectalmacen: selectalmacen.text),
                        builder: (ctx, snp) {
                          if (snp.hasData) {
                            List<Map> listproducts = snp.data!;
                            return ListView.builder(
                                itemCount: listproducts.length,
                                itemBuilder: (ctx, index) {
                                  return Card(
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        color:
                                            Color.fromARGB(255, 19, 104, 231),
                                        size: 40,
                                      ),
                                      title: Text(
                                        "${listproducts[index]['evento']}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 22, 112, 248)),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            "Nombre: ${listproducts[index]['nombre']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 19, 103, 230)),
                                          ),
                                          Text(
                                            "Ingreso: ${listproducts[index]['ingreso']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 26, 112, 240)),
                                          ),
                                          Text(
                                            "Salida: ${listproducts[index]['salida']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 26, 112, 240)),
                                          ),
                                          Text(
                                            "Salida: ${listproducts[index]['zona']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 26, 112, 240)),
                                          ),
                                        ],
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResultadosInvitados(
                                                id: listproducts[index]['id']
                                                    .toString(),
                                                codigo: listproducts[index]
                                                    ['codigo'],
                                                documento: listproducts[index]
                                                    ['documento'],
                                                nombre: listproducts[index]
                                                    ['nombre'],
                                                evento: listproducts[index]
                                                    ['evento'],
                                                zonas: listproducts[index]
                                                    ['zona'],
                                                ingreso: listproducts[index]['ingreso'],
                                                salida: listproducts[index]['salida'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.remove_red_eye_sharp,
                                          color: Color.fromARGB(255, 35, 122, 252),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 49, 129, 248),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const SizedBox(
                        child: Text(
                          'CANCELAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'GUARDAR',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 31, 119, 250)),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: nameexcel,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 36, 124, 255)),
                                      decoration: InputDecoration(
                                        labelText: 'Digitar el nombre',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    String name = nameexcel.text
                                        .trim()
                                        .replaceAll(' ', '_');
                                    String nombretabla =
                                        _selectedItem.toString();
                                    if (name != '') {
                                      convertTableToExcel(name, nombretabla);
                                      Navigator.of(context).pop();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                            'ADVERTIENCIA!',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 37, 120, 245)),
                                          ),
                                          content: const Text(
                                            'RELLENE EL CAMPO NOMBRE',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 39, 126, 255)),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 30, 120, 255),
                                                shape: const StadiumBorder(),
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                              ),
                                              child: const Text(
                                                'ACEPTAR',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 39, 122, 248),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Text(
                                    'ACEPTAR',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromARGB(255, 51, 133, 255),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Text(
                                    'CANCELAR',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 52, 133, 255),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: const SizedBox(
                        child: Text(
                          'EXPORTAR A EXCEL',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: const Text(
                                "ADVERTENCIA!!",
                                textAlign: TextAlign.center,
                              ),
                              content: const SizedBox(
                                height: 80,
                                child: Column(
                                  children: [
                                    Text(
                                      "¿Esta seguro de eliminar el registro de invitados que asistieron al evento?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    String evento = selectalmacen.text;
                                    if (evento != "" &&
                                        evento != "SELECCIONAR EVENTO") {
                                      int rep = await sqLdb.deleteData(
                                          "DELETE FROM resultados WHERE evento = '$evento'");
                                      
                                      if (rep > 0 ) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title:
                                                      const Text("Mensaje!!"),
                                                  content: const Text(
                                                      "Los datos fueron eliminados"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {});
                                                        },
                                                        child: const Text(
                                                            "Aceptar"))
                                                  ],
                                                ));
                                      }
                                    } else {
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text("Mensaje!!"),
                                                content: const Text(
                                                    "SELECCIONE UN EVENTO"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {});
                                                      },
                                                      child:
                                                          const Text("Aceptar"))
                                                ],
                                              ));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 30, 120, 255),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Text(
                                    'ACEPTAR',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 30, 120, 255),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 34, 120, 250),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: const SizedBox(
                    child: Text(
                      'ELIMINAR REGISTROS',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
