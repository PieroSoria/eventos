// ignore_for_file: unused_local_variable, prefer_const_declarations, depend_on_referenced_packages, unrelated_type_equality_checks, unused_import, use_build_context_synchronously

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:navigator/navigator.dart';

import 'package:mysql1/mysql1.dart';
import 'package:eventos/page/models.dart';

import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController rucController = TextEditingController();
  final TextEditingController razonsocialController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();
  final TextEditingController fechaingresoController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();
  final TextEditingController selectedpaisController = TextEditingController();

  List<String> dataList = ['PERU', 'CHILE', 'COLOMBIA','BRASIL','MEXICO','ECUADOR','PANAMA','COSTA RICA', 'REPUBLICA DOMINICANA', 'EL SALVADOR','GUATEMALA','HONDURAS','PARAGUAY','ARGENTINA','BOLIVIA','HALTI','VENEZUELA','ESPAÑA','ITALIA','PORTUGAL','FRANCIA','ALEMANIA','NICARAGUA','SAN CRISTOBAL','ANTIGUA Y BARBUDA','BAHAMAS','BARBADOS','BELICE','ESTADOS UNIDOS','GRANADA','GUYANA','JAMAICA','CANADA','CUBA'];
  

  String? selectpais;
  String? selectpro;
  String? selectdis;

  

  Future<void> guardardatos(
      String nombreController,
      String userController,
      String telefonoController,
      String rucController,
      String razonsocialController,
      String selectedpaisController,
      String direccionController,
      ) async {
    final nombre = nombreController;
    final correo = userController;
    final telefono = telefonoController;
    final ruc = rucController;
    final razonsocial = razonsocialController;
    final pais = selectedpaisController;
    final direccion = direccionController;
    final DateTime fecha = DateTime.now();
    final hoy = DateFormat('yyyy-MM-dd').format(fecha);
    final int nlicencia = 1;
    final dblogin = SQLlogin();
    final datosuser = Datosusuario(
        nombres: nombre,
        correo: correo,
        telefono: telefono,
        ruc: ruc,
        razonsocial: razonsocial,
        pais: pais,
        direccion: direccion,
        fecharegistro: hoy,
        nlicenciafree: nlicencia,
        nlicenciaanual: nlicencia);
    dblogin.insertClientes(datosuser);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MENSAJE',
            style: TextStyle(color: Color.fromARGB(255, 25, 108, 233)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'LOS DATOS SE INSERTARON CORRECTAMENTE',
                  style: TextStyle(fontSize: 18, color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 31, 112, 235),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text('ACEPTAR',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.blue,
          ],
        ),
      ),
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('REGISTRE SU EMPRESA'),
            backgroundColor: const Color.fromARGB(255, 32, 84, 253),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: Colors.grey.shade200,
          body: _form(),
        );
      }),
    );
  }

  Widget _form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade200,
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: Column(
                          children: [
                            const Text(
                              'INFORMACION DE LA EMPRESA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 30, 109, 228)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'SELECCIONAR PAIS',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 43, 123, 241),
                                  fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            DropdownButton<String>(
                              value: selectpais,
                              onChanged: (String? selectedValue) async {
                                setState(() {
                                  selectedpaisController.text =
                                      selectedValue ?? '';
                                  selectpais = selectedValue!;
                                });
                              },
                              items: dataList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 51, 122, 230),
                              ),
                              dropdownColor: Colors.white,
                              hint: const SizedBox(
                                width: 235,
                                child: Text(
                                  'PAIS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 29, 111, 233),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _inputField('INGRESE RUC', true, rucController),
                            const SizedBox(
                              height: 20,
                            ),
                            _inputField(
                                'RAZON SOCIAL', false, razonsocialController),
                            const SizedBox(
                              height: 18,
                            ),
                            _inputField('DIRECCION Y DISTRITO', false,
                                direccionController),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade200,
                        Colors.grey.shade200,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'INFORMACION DEL CONTACTO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Color.fromARGB(255, 42, 122, 241),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        _inputField(
                            'NOMBRE DEL CONTACTO', false, nombreController),
                        const SizedBox(
                          height: 20,
                        ),
                        _inputField('TELEFONO', true, telefonoController),
                        const SizedBox(
                          height: 18,
                        ),
                        _inputField('CORREO', false, userController),
                        const SizedBox(
                          height: 20,
                        ),
                        _registrarbtn(),
                        const SizedBox(
                          height: 18,
                        ),
                        _backbtn(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      String hinText, bool only, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color.fromARGB(255, 31, 115, 241)),
    );
    if (only) {
      return TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.blue.shade900,
        ),
        textCapitalization: TextCapitalization.characters,
        controller: controller,
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 33, 117, 241),
          ),
          enabledBorder: border,
          focusedBorder: border,
        ),
        obscureText: isPassword,
      );
    } else {
      return TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 24, 109, 238),
        ),
        textCapitalization: TextCapitalization.characters,
        controller: controller,
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 117, 245),
          ),
          enabledBorder: border,
          focusedBorder: border,
        ),
        obscureText: isPassword,
      );
    }
  }

  Widget _registrarbtn() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("nombre : ${nombreController.text}");
        debugPrint("user : ${userController.text}");
        debugPrint("telefono : ${telefonoController.text}");
        debugPrint("ruc : ${rucController.text}");
        debugPrint("razonSocial : ${razonsocialController.text}");
        debugPrint("pais : ${selectedpaisController.text}");
        debugPrint("direccion : ${direccionController.text}");
        debugPrint("distrito : ${distritoController.text}");
        debugPrint("provincia : ${provinciaController.text}");

        String nombre = nombreController.text;
        String user = userController.text;
        String telefono = telefonoController.text;
        String ruc = rucController.text;
        String razonsocial = razonsocialController.text;
        String direccion = direccionController.text;
        String pais = selectedpaisController.text;

        if (nombre != '' &&
            user != '' &&
            telefono != '' &&
            ruc != '' &&
            razonsocial != '' &&
            pais != '' &&
            direccion != '') {
          guardardatos(
              nombreController.text,
              userController.text,
              telefonoController.text,
              rucController.text,
              razonsocialController.text,
              selectedpaisController.text,
              direccionController.text,
              );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'ADVERTENCIA',
                  style: TextStyle(color: Color.fromARGB(255, 33, 114, 236)),
                ),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'REVISE QUE TODOS LOS CAMPOS ESTE CORRECTAMENTE LLENADOS',
                        style: TextStyle(
                            fontSize: 18, color: Color.fromARGB(255, 33, 110, 226)),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 39, 124, 250),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text('ACEPTAR',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 37, 119, 243),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(16.0),
      ),
      child: const SizedBox(
        width: 270,
        child: Text(
          'Guardar Datos',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _backbtn() {
    return Builder(builder: (context) {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 50, 129, 248),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(16.0),
        ),
        icon: const Icon(Icons.arrow_back),
        label: const Text(
          'Volver al menu principal',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    });
  }
}
