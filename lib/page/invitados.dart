import 'package:eventos/page/actualizarinvitados.dart';
import 'package:eventos/page/database.dart';
import 'package:flutter/material.dart';

class Invitados extends StatefulWidget {
  const Invitados({super.key});

  @override
  State<Invitados> createState() => _InvitadosState();
}

class _InvitadosState extends State<Invitados> {
  TextEditingController selectalmacen = TextEditingController();
  TextEditingController selectalmacen2 = TextEditingController();
  TextEditingController clave = TextEditingController();
  String? _selectedItem;
  String? _selectedItem2;
  List<String> dropdownItems = [];
  List<String> dropdownItems2 = [];
  SQLdb sqLdb = SQLdb();
  List<Map> invitadosList = [];

  @override
  void initState() {
    initDropdownItems();
    initDropdownItems2();
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

  Future<void> initDropdownItems2() async {
    dropdownItems2 = await sqLdb.captureData2();
    setState(() {
      // Set the initial selected item
      if (dropdownItems2.isNotEmpty) {
        _selectedItem2 = dropdownItems2.first;
      }
    });
  }

  Future<void> refreshdata() async {
    await getAllProducts();
  }

  Future<void> getAllProducts() async {
    String query = "SELECT * FROM invitados";
    if (_selectedItem == "SELECCIONAR EVENTO" &&
        _selectedItem2 == "SELECCIONAR ZONA") {
      query;
    } else if (_selectedItem != null &&
        _selectedItem != "SELECCIONAR EVENTO" &&
        _selectedItem2 == "SELECCIONAR ZONA") {
      query += " WHERE evento = '$_selectedItem'";
    } else if (_selectedItem2 != null &&
        _selectedItem2 != "SELECCIONAR ZONA" &&
        _selectedItem == "SELECCIONAR EVENTO") {
      query += " WHERE zona = '$_selectedItem2'";
    } else if (_selectedItem != "SELECCIONAR EVENTO" &&
        _selectedItem2 != "SELECCIONAR ZONA") {
      query += " WHERE evento = '$_selectedItem' AND zona = '$_selectedItem2'";
    }
    invitadosList = await sqLdb.getData(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: RefreshIndicator(
          onRefresh: refreshdata,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
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
                  ElevatedButton(
                    onPressed: () async {
                      String evento = selectalmacen.text;
                      if (evento != "" && evento != "SELECCIONAR EVENTO") {
                        int rep = await sqLdb.deleteData(
                            "DELETE FROM invitados WHERE evento = '$evento'");
                        if (rep > 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'MENSAJE!',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 37, 120, 245)),
                            ),
                            content: const Text(
                              'Seleccione un evento antes de continuar o se eliminara todos los invitados de la lista de invitados',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 39, 126, 255)),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  int rep = await sqLdb
                                      .deleteData("DELETE FROM invitados");
                                  if (rep > 0) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                "Mensaje!!",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 37, 120, 245)),
                                              ),
                                              content: const Text(
                                                  "Se eliminaron satisfactoriamente",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 39, 126, 255))),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 30, 120, 255),
                                                    shape:
                                                        const StadiumBorder(),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                  ),
                                                  child: const Text(
                                                    'ACEPTAR',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
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
                                  'CONTINUAR',
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
                                  'CANCELAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 30, 120, 255),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const Text(
                      'BORRAR LA LISTA',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'LISTADO DE INVITADOS',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getAllProducts(),
                      builder: (ctx, snp) {
                        if (invitadosList.isNotEmpty) {
                          return ListView.builder(
                              itemCount: invitadosList.length,
                              itemBuilder: (ctx, index) {
                                return Card(
                                  child: ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        color:
                                            Color.fromARGB(255, 19, 101, 224),
                                        size: 36,
                                      ),
                                      title: Text(
                                        "${invitadosList[index]['codigo']}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 19, 102, 226)),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Text(
                                            "Nombre: ${invitadosList[index]['nombre']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 16, 99, 223)),
                                          ),
                                        ],
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                        'Inserte contraseña',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    120,
                                                                    245)),
                                                      ),
                                                      content: TextField(
                                                        controller: clave,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                "Contraseña",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (clave.text ==
                                                                "RMC123") {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Actualizarinvitados(
                                                                    id: invitadosList[index]
                                                                            [
                                                                            'id']
                                                                        .toString(),
                                                                    codigo: invitadosList[
                                                                            index]
                                                                        [
                                                                        'codigo'],
                                                                    documento: invitadosList[
                                                                            index]
                                                                        [
                                                                        'documento'],
                                                                    nombre: invitadosList[
                                                                            index]
                                                                        [
                                                                        'nombre'],
                                                                    evento: invitadosList[
                                                                            index]
                                                                        [
                                                                        'evento'],
                                                                    zonas: invitadosList[
                                                                            index]
                                                                        [
                                                                        'zona'],
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    'MENSAJE!',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            37,
                                                                            120,
                                                                            245)),
                                                                  ),
                                                                  content:
                                                                      const Text(
                                                                    'Contrasena incorrecta',
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            39,
                                                                            126,
                                                                            255)),
                                                                  ),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        foregroundColor:
                                                                            Colors.white,
                                                                        backgroundColor: const Color.fromARGB(
                                                                            255,
                                                                            30,
                                                                            120,
                                                                            255),
                                                                        shape:
                                                                            const StadiumBorder(),
                                                                        padding:
                                                                            const EdgeInsets.all(16.0),
                                                                      ),
                                                                      child:
                                                                          const Text(
                                                                        'ACEPTAR',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    30,
                                                                    120,
                                                                    255),
                                                            shape:
                                                                const StadiumBorder(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                          ),
                                                          child: const Text(
                                                            'ACEPTAR',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              clave.text = '';
                                                            });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    30,
                                                                    120,
                                                                    255),
                                                            shape:
                                                                const StadiumBorder(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                          ),
                                                          child: const Text(
                                                            'CANCELAR',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Color.fromARGB(
                                                      255, 54, 134, 255),
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                        'Inserte contraseña',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    120,
                                                                    245)),
                                                      ),
                                                      content: TextField(
                                                        controller: clave,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                "Contraseña",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            if (clave.text ==
                                                                "RMC123") {
                                                              int rep = await sqLdb
                                                                  .deleteData(
                                                                      "DELETE FROM invitados WHERE codigo = '${invitadosList[index]['codigo']}'");
                                                              int rep2 = await sqLdb
                                                                  .deleteData(
                                                                      "DELETE FROM resultados WHERE codigo = '${invitadosList[index]['codigo']}'");
                                                              if (rep > 0) {
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                // ignore: use_build_context_synchronously
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      'MENSAJE!',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              37,
                                                                              120,
                                                                              245)),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                      'LOS DATOS DEL INVITADO SE ELIMINO EXITOSAMENTE',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              39,
                                                                              126,
                                                                              255)),
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          setState(
                                                                              () {
                                                                            clave.text =
                                                                                '';
                                                                          });
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              Colors.white,
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              120,
                                                                              255),
                                                                          shape:
                                                                              const StadiumBorder(),
                                                                          padding:
                                                                              const EdgeInsets.all(16.0),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'ACEPTAR',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else if (rep >
                                                                      0 &&
                                                                  rep2 > 0) {
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                // ignore: use_build_context_synchronously
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      'MENSAJE!',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              37,
                                                                              120,
                                                                              245)),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                      'LOS DATOS DEL INVITADO SE ELIMINO EXITOSAMENTE',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              39,
                                                                              126,
                                                                              255)),
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              Colors.white,
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              120,
                                                                              255),
                                                                          shape:
                                                                              const StadiumBorder(),
                                                                          padding:
                                                                              const EdgeInsets.all(16.0),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'ACEPTAR',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    30,
                                                                    120,
                                                                    255),
                                                            shape:
                                                                const StadiumBorder(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                          ),
                                                          child: const Text(
                                                            'ACEPTAR',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              clave.text = '';
                                                            });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    30,
                                                                    120,
                                                                    255),
                                                            shape:
                                                                const StadiumBorder(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                          ),
                                                          child: const Text(
                                                            'CANCELAR',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Color.fromARGB(
                                                      255, 3, 140, 231),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
