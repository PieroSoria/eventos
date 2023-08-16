import 'package:eventos/page/actualizar.dart';
import 'package:eventos/page/actualizarzona.dart';
import 'package:eventos/page/database.dart';
import 'package:eventos/page/index.dart';
import 'package:flutter/material.dart';

class EventosyZonas extends StatefulWidget {
  final Index widget;
  const EventosyZonas({super.key, required this.widget});

  @override
  State<EventosyZonas> createState() => _EventosyZonasState();
}

class _EventosyZonasState extends State<EventosyZonas> {
  SQLdb sqLdb = SQLdb();
  FocusNode _focusNode = FocusNode();
  bool _switchValue = false;
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  Future<List<Map>> getAllProducts({String? searchText}) async {
    if (_switchValue == false) {
      String query = "SELECT * FROM 'eventos'";
      if (searchText != null && searchText.isNotEmpty) {
        query += " WHERE nombre LIKE '%$searchText%'";
      }
      List<Map> products = await sqLdb.getData(query);
      return products;
    }else{
      String query = "SELECT * FROM 'zonas'";
      if (searchText != null && searchText.isNotEmpty){
        query += "WHERE nombre LIKE '%$searchText%'";
      }
      List<Map> products = await sqLdb.getData(query);
      return products;
    }
  }

  Future<void> refreshdata() async {
    setState(() {
      getAllProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  Future<void> insertarevento(String eventos) async {
    const estado = 'ACTIVO';
    final double fin = await sqLdb.getNext3();
    final evento = Eventos(id: fin, nombre: eventos, estado: estado);
    sqLdb.insertevento(evento);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MENSAJE',
            style: TextStyle(color: Color.fromARGB(255, 23, 113, 247)),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'EL EVENTO SE GUARDO CORRECTAMENTE',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 24, 107, 231)),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                searchText = '';
                setState(() {
                  refreshdata();
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 19, 102, 226),
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
  Future<void> insertarzona(String zonas) async {
    const estado = 'ACTIVO';
    final double fin = await sqLdb.getNext4();
    final zona = Eventos(id: fin, nombre: zonas, estado: estado);
    sqLdb.insertarzona(zona);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MENSAJE',
            style: TextStyle(color: Color.fromARGB(255, 16, 99, 224)),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'LA ZONA SE GUARDO CORRECTAMENTE',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 19, 103, 228)),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                searchText = '';
                setState(() {
                  refreshdata();
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 24, 106, 230),
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
      extendBody: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: refreshdata,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.widget.user,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 32, 145, 238)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Eventos"),
                    Switch(
                        value: _switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _switchValue = value;
                            _focusNode = FocusNode();
                            _focusNode.requestFocus();
                          });
                        }),
                    const Text("Zonas")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_switchValue == true) _zonas(),
                if (_switchValue == false) _eventos(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventos() {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'EVENTOS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 32, 145, 238)),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
                labelText: 'Ingrese el nombre del evento',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  searchController.text = '';
                  searchText = '';
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 32, 145, 238),
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
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String eventos = searchController.text;
                  await insertarevento(eventos);
                  searchController.text = '';
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 56, 136, 255),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const SizedBox(
                  child: Text(
                    'GUARDAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'LISTADO DE EVENTOS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color:Color.fromARGB(255, 32, 145, 238)),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: FutureBuilder(
                  future: getAllProducts(searchText: searchText),
                  builder: (ctx, snp) {
                    if (snp.hasData) {
                      List<Map> listproducts = snp.data!;
                      return ListView.builder(
                          itemCount: listproducts.length,
                          itemBuilder: (ctx, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.add_home_outlined,
                                  color: Color.fromARGB(255, 49, 128, 247),
                                  size: 20,
                                ),
                                title: Text(
                                  "${listproducts[index]['nombre']}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 26, 111, 240)),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Actualizar(
                                                id: listproducts[index]['id']
                                                    .toString(),
                                                nombre: listproducts[index]
                                                    ['nombre'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color.fromARGB(255, 34, 114, 235),
                                          size: 25,
                                        )),
                                  ],
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
        ],
      ),
    );
  }

  Widget _zonas() {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'ZONAS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 32, 145, 238)),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
                labelText: 'Ingrese el nombre de la zona',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  searchController.text = '';
                  searchText = '';
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 32, 145, 238),
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
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String zonas = searchController.text;
                  await insertarzona(zonas);
                  searchController.text = '';
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 53, 159, 245),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const SizedBox(
                  child: Text(
                    'GUARDAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'LISTADO DE ZONAS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 32, 145, 238)),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: FutureBuilder(
                  future: getAllProducts(searchText: searchText),
                  builder: (ctx, snp) {
                    if (snp.hasData) {
                      List<Map> listproducts = snp.data!;
                      return ListView.builder(
                          itemCount: listproducts.length,
                          itemBuilder: (ctx, index) {
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.add_home_outlined,
                                  color: Color.fromARGB(255, 32, 145, 238),
                                  size: 20,
                                ),
                                title: Text(
                                  "${listproducts[index]['nombre']}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 32, 145, 238)),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Actualizar2(
                                                id: listproducts[index]['id']
                                                    .toString(),
                                                nombre: listproducts[index]
                                                    ['nombre'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color.fromARGB(255, 32, 145, 238),
                                          size: 25,
                                        )),
                                  ],
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
        ],
      ),
    );
  }
}
