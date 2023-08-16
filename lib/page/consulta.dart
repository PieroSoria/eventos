import 'package:eventos/page/database.dart';
import 'package:eventos/page/index.dart';
import 'package:flutter/material.dart';

class Consulta extends StatefulWidget {
  final Index widget;
  const Consulta({super.key, required this.widget});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  TextEditingController selectalmacen = TextEditingController();
  SQLdb sqLdb = SQLdb();
  String? _selectedItem;
  List<Map> products = [];

  int dataCount = 0;
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  List<String> dropdownItems = ["TODOS", "INGRESOS", "SALIDAS"];

  Future<List<Map>> getAllProducts({required String selectalmacen}) async {
    String query = "SELECT * FROM resultados";
    if (selectalmacen == "TODOS") {
      query;
    } else if (selectalmacen == "INGRESOS") {
      query += " WHERE ingreso IS NOT NULL AND ingreso != ''";
    } else if (selectalmacen == "SALIDAS") {
      query += " WHERE salida IS NOT NULL AND salida != ''";
    }

    List<Map> products = await sqLdb.getData(query);
    return products;
  }

  Future<void> refreshData() async {
    final newProducts = await getAllProducts(selectalmacen: selectalmacen.text);
    setState(() {
      products = newProducts;
      dataCount = products.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedItem = dropdownItems.first;
    refreshData().then((_) {
      setState(() {
        products = products;
        dataCount = products.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 160,
                  ),
                  Text(
                    'cantidad de datos: $dataCount',
                    style:
                        const TextStyle(
                          color: Color.fromRGBO(2, 120, 255, 1),
                          fontSize: 20
                        ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(widget.widget.user,style: const TextStyle(fontSize: 20, color: Color.fromRGBO(2, 120, 255, 1)),),
                ],
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
                onChanged: (String? selectedItem) async {
                  if (dropdownItems.contains(selectedItem)) {
                    setState(() {
                      _selectedItem = selectedItem!;
                      selectalmacen.text = _selectedItem.toString();
                    });
                    await refreshData();
                  }
                },
                style: const TextStyle(
                    color: Color.fromARGB(255, 15, 95, 216), fontSize: 18),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getAllProducts(selectalmacen: selectalmacen.text),
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
                                  color: Color.fromARGB(255, 20, 104, 230),
                                  size: 36,
                                ),
                                title: Text(
                                  "${listproducts[index]['codigo']}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 20, 104, 230)),
                                ),
                                subtitle: Column(
                                  children: [
                                    Text(
                                      "${listproducts[index]['nombre']}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_selectedItem == "TODOS")
                                      Text(
                                        "${listproducts[index]['ingreso']}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    if (_selectedItem == "INGRESOS")
                                      Text(
                                        "${listproducts[index]['ingreso']}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    if (_selectedItem == "SALIDAS")
                                      Text(
                                        "${listproducts[index]['salida']}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14),
                                      )
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
            ],
          ),
        ),
      ),
    );
  }
}
