// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:eventos/page/models.dart';

class Userruc extends StatefulWidget {
  const Userruc({super.key});

  @override
  State<Userruc> createState() => _UserrucState();
}

class _UserrucState extends State<Userruc> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController rucController = TextEditingController();
  final TextEditingController anualController = TextEditingController();

  List<String> licencias = [
    'ASDN28112NJN23HFIWS02',
    '1923NASD091NSD1123DS2',
    'DM129304SNDA0ASOKD12H',
    'JIJ1022394USDU1NBAV0X',
    '1J241923DJFDSNWSASD23',
    'SDIFJLKF99Q34NDS0F0AS',
    'MSAD9U01U2039120SDIFH',
    'ASD1823JFD9USF21O3ASD',
    'SJDF9124N3NCOV0SDLA9U',
    'MLASD9DN234KN0FD2348F',
    '03FSD0F0790FDS0UFQ3NI',
    'KASDI10824083Y2934NSD',
    'FOSIDNFO0293400FD82H0',
    'ASDNAUSDIUASIDUQUWHQI',
    'DASNDOIUS918W98112SAJ',
    'ASDNOAUISHFUDGDBSFN23',
    'ASD8H108H918BF8SHV9MA',
    'PDAMSDPIJ102J41F8DS0D',
    'DKANSODI109823012BVPU',
    'QKWNEOQ01U23081HLKJFN'
  ];

  SQLlogin funciones = SQLlogin();

  void insertlicencia() {}

  Future<void> registrar(String userController, String passController,
      String rucController, String mus) async {
    bool rango = await funciones.compararCantidadLicencias();
    final ruc = rucController;
    bool verirucs = await funciones.veriruc(ruc);
    if (rango == true && verirucs == true) {
      final username = userController;
      final pass = passController;
      final ruc = rucController;
      final DateTime fecha = DateTime.now();
      final hoy = DateFormat('yyyy-MM-dd').format(fecha);
      final timefin = fecha.add(const Duration(days: 7));
      final fin = DateFormat('yyyy-MM-dd').format(timefin);
      final dblogin = SQLlogin();
      final datosinsert = User(
          username: username,
          password: pass,
          ruc: ruc,
          fechareg: hoy,
          fechafinal: fin);
      dblogin.insertUser(datosinsert);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'MENSAJE',
              style: TextStyle(color: Colors.blue.shade900),
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
                  Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 49, 129, 250),
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
    } else if (rango == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'MENSAJE',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 42, 118, 231)),
              ),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'ESTA OPCION YA NO ESTA DISPONIBLE, ADQUIERA UNA LICENCIA ANUAL',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 47, 128, 250)),
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
                    backgroundColor: const Color.fromARGB(255, 50, 132, 255),
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
          });
    } else if (verirucs == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'MENSAJE',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 42, 119, 235)),
              ),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'SU EMPRESA NO ESTA REGISTRADO',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 47, 125, 241)),
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
                    backgroundColor: const Color.fromARGB(255, 54, 129, 241),
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
          });
    }
  }

  Future<bool> buscarcoincidencia(String anual) async {
    String text = anual.toLowerCase();
    for (String elemento in licencias) {
      if (elemento.toLowerCase() == text) {
        return true;
      }
    }
    return false;
  }

  Future<void> registraranual(
      String user, String pass, String ruc, String anual) async {
    // bool coincidencia = await buscarcoincidencia(anual);
    bool verilicencia = await funciones.getLicencia(anual);
    bool rango = await funciones.compararCantidadLicencias2();
    bool verirucs = await funciones.veriruc(ruc);
    if (verilicencia == true && rango == true && verirucs == true) {
      final usuario = user.toString();
      final password = pass.toString();
      final rucs = ruc.toString();
      final DateTime fecha = DateTime.now();
      final hoy = DateFormat('yyyy-MM-dd').format(fecha);
      final future = fecha.add(const Duration(days: 366));
      final fin = DateFormat('yyyy-MM-dd').format(future);
      final dblogin = SQLlogin();
      final datosinsert = User(
          username: usuario,
          password: password,
          ruc: rucs,
          fechareg: hoy,
          fechafinal: fin);
      dblogin.insertUser2(datosinsert);
      dblogin.actualizarlicencia(anual);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Los datos se insertaron correctamente.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 37, 119, 241),
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
    } else if (verilicencia == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'MENSAJE',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 38, 117, 236)),
              ),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'LA LICENCIA NO ES VALIDA',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 44, 120, 235)),
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
                    backgroundColor: const Color.fromARGB(255, 44, 124, 243),
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
          });
    } else if (rango == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'MENSAJE',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 38, 120, 243)),
              ),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'LA CANTIDAD DE USUARIO YA ESTA LLENO',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 41, 120, 238)),
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
                    backgroundColor: const Color.fromARGB(255, 41, 120, 240),
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
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'CREE SU USUARIO DEL SISTEMA',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 33, 111, 228),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.grey.shade200,
        body: _page(),
      );
    });
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade200,
              Colors.grey.shade200,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'USUARIO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 29, 109, 230),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  _inputField('Ingrese su usuario', false, userController),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'CONTRASEÑA',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Color.fromARGB(255, 34, 115, 235)),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  _inputField('Ingrese una contraseña', false, passController,
                      isPassword: true),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'RUC DE SU EMPRESA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 35, 114, 233),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  _inputField(
                      'Ingrese el Ruc de su empresa', true, rucController),
                  const SizedBox(
                    height: 20,
                  ),
                  _btnregistrar(),
                  const SizedBox(
                    height: 20,
                  ),
                  _btnregistraranual(),
                  const SizedBox(
                    height: 20,
                  ),
                  _backebtn(),
                ],
              ),
            ),
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
      borderSide: const BorderSide(color: Color.fromARGB(255, 35, 117, 240)),
    );
    if (only) {
      return TextField(
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.blue.shade900,
        ),
        controller: controller,
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 110, 226),
          ),
          enabledBorder: border,
          focusedBorder: border,
        ),
        obscureText: isPassword,
      );
    } else {
      return TextField(
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(
          color: Color.fromARGB(255, 31, 112, 233),
        ),
        controller: controller,
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 33, 113, 233),
          ),
          enabledBorder: border,
          focusedBorder: border,
        ),
        obscureText: isPassword,
      );
    }
  }

  Widget _btnregistrar() {
    return ElevatedButton(
      onPressed: () {
        String user = userController.text;
        String pass = passController.text;
        String ruc = rucController.text;
        String mus = '1';
        if (user != '' && pass != '' && ruc != '') {
          registrar(userController.text, passController.text,
              rucController.text, mus);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'MENSAJE',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text(
                          'PORFAVOR, RELLENE SUS DATOS CORRECTAMENTE',
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
                      child: const Text('ACEPTAR'),
                    ),
                  ],
                );
              });
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 39, 118, 236),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(16.0),
      ),
      child: const SizedBox(
        width: 500,
        child: Text(
          'REGISTRAR EL USUARIO CON LA LICENCIA FREE',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _btnregistraranual() {
    return ElevatedButton(
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Container(
                  width: 600,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade200,
                        Colors.grey.shade200,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          height: 180.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                _inputField('INGRESE LA LICENCIA ADQUIRIDA',
                                    false, anualController),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                String user = userController.text;
                                String pass = passController.text;
                                String ruc = rucController.text;
                                String anual = anualController.text;
                                if (user != '' &&
                                    pass != '' &&
                                    ruc != '' &&
                                    anual != '') {
                                  registraranual(user, pass, ruc, anual);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'MENSAJE',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          content: const SingleChildScrollView(
                                            child: ListBody(
                                              children: [
                                                Text(
                                                  'PORFAVOR RELLENE SUS DATOS CORRECTAMENTE',
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
                                              child: const Text('ACEPTAR'),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromARGB(255, 42, 120, 238),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: const Text(
                                'ACEPTAR',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromARGB(255, 34, 114, 233),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: const Text(
                                'CANCELAR',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 112, 235),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(16.0),
      ),
      child: const SizedBox(
        width: 500,
        child: Text(
          'REGISTRAR EL USUARIO CON LA LICENCIA ANUAL',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _backebtn() {
    return Builder(builder: (context) {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 32, 108, 223),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(16.0),
        ),
        icon: const Icon(Icons.arrow_back),
        label: const Text(
          'Volver al menu principal',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
      );
    });
  }
}
