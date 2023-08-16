// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:eventos/page/userruc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventos/page/index.dart';
import 'package:eventos/page/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController configController = TextEditingController();
  TextEditingController licenciaController = TextEditingController();
  SQLlogin funciones = SQLlogin();
  String _imagePath = '';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    _loadImagePathFromPreferences();
    super.initState();
  }

  Future<void> accesoconfig(BuildContext context, String clave) async {
    if (clave == 'RMC123') {
      Navigator.pushNamed(context, '/config');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('MENSAJE'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'CLAVE INCORRECTA',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('ACEPTAR'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _renovar(
      BuildContext context, String licencia, String user) async {
    bool verilicencia = await funciones.getLicencia(licencia);
    if (verilicencia == true) {
      final actua = await funciones.actualizarlicencia(licencia);
      final actua2 = await funciones.actualizarusuario(user);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SE ACTUALIZO SU LICENCIA',
            style: TextStyle(color: Color.fromARGB(255, 31, 111, 231)),
          ),
          content: const Text(
            'YA PUEDE USAR SU USUARIO',
            style: TextStyle(color: Color.fromARGB(255, 34, 122, 253)),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 42, 123, 245),
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SU LICENCIA NO EXISTE',
            style: TextStyle(color: Color.fromARGB(255, 48, 127, 245)),
          ),
          content: const Text(
            'INGRESE SU LICENCIA COMPRADA',
            style: TextStyle(color: Color.fromARGB(255, 37, 119, 243)),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 46, 123, 238),
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
  }

  Future<void> _login(BuildContext context) async {
    final username = userController.text;
    final password = passController.text;
    final sqlLogin = SQLlogin();
    final bool resultado = await sqlLogin.buscarUsuariofree(username, password);
    final bool resultado2 =
        await sqlLogin.buscarUsuarioanual(username, password);
    final bool tiempo = await sqlLogin.compararFechaFinalfree(username);
    final bool tiempo2 = await sqlLogin.compararFechaFinalanual(username);
    debugPrint('$resultado + $tiempo');
    debugPrint('$resultado2 + $tiempo2');
    debugPrint('$resultado + $resultado2');
    if (resultado == true && tiempo == true) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Index(user:username)));
    } else if (resultado2 == true && tiempo2 == true) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Index(user:username)));
    } else if (resultado == true && tiempo == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'FINALIZO SU LICENCIA FREE',
            style: TextStyle(color: Colors.blue.shade900),
          ),
          content: Text(
            'OBTENGA UNA LICENCIA ANUAL PARA CONTINUAR',
            style: TextStyle(color: Colors.blue.shade900),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Userruc())),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 45, 123, 240),
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
                backgroundColor: const Color.fromARGB(255, 39, 120, 241),
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
    } else if (resultado2 == true && tiempo2 == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'FINALIZO SU LICENCIA ANUAL',
            style: TextStyle(color: Color.fromARGB(255, 42, 123, 245)),
          ),
          content: const Text(
            'RENUEVE SU LICENCIA ANUAL',
            style: TextStyle(color: Color.fromARGB(255, 50, 131, 252)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'RENUEVE SU LICENCIA ANUAL',
                        style: TextStyle(color: Color.fromARGB(255, 41, 124, 248)),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            const Text(
                              'INGRESE SU NUEVA LICENCIA',
                              style: TextStyle(
                                  fontSize: 18, color: Color.fromARGB(255, 54, 127, 236)),
                            ),
                            _inputField2('Nueva licencia', licenciaController),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            String user = username;
                            String licencia = licenciaController.text;
                            if (licencia != '') {
                              _renovar(context, licencia, user);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'ADVERTIENCIA!',
                                    style:
                                        TextStyle(color: Color.fromARGB(255, 46, 127, 250)),
                                  ),
                                  content: const Text(
                                    'RELLENE EL CAMPO LICENCIA',
                                    style:
                                        TextStyle(color: Color.fromARGB(255, 59, 131, 240)),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromARGB(255, 42, 121, 240),
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
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 40, 120, 240),
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
                            backgroundColor: const Color.fromARGB(255, 51, 126, 238),
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
                backgroundColor: const Color.fromARGB(255, 50, 132, 255),
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
                backgroundColor: const Color.fromARGB(255, 47, 122, 236),
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
    } else if (resultado == false || resultado2 == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Error de inicio de sesión',
            style: TextStyle(color: Color.fromARGB(255, 36, 120, 247)),
          ),
          content: const Text(
            'Las credenciales son inválidas.',
            style: TextStyle(color: Color.fromARGB(255, 43, 126, 250)),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 46, 128, 252),
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
  }

  Future<void> _loadImagePathFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('imagePath') ?? _imagePath;
    });
  }

  Future<void> _saveImagePathToPreferences(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', imagePath);
  }

  Future<void> _selectImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String imagePath = image.path;
      setState(() {
        _imagePath = imagePath;
      });
      await _saveImagePathToPreferences(imagePath);
      await _loadImagePathFromPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _page(),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                FittedBox(
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: _imagePath.isNotEmpty
                          ? FileImage(File(_imagePath)) as ImageProvider<Object>?
                          : const AssetImage('assets/image/logo1.jpg'),
                      radius: 150,
                      
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _selectImageFromGallery,
                    backgroundColor: const Color.fromARGB(255, 42, 118, 233),
                    child: const Icon(Icons.image),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'INGRESE SU USUARIO',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 39, 113, 224)),
            ),
            const SizedBox(
              height: 30,
            ),
            _inputField("Usuario", userController),
            const SizedBox(
              height: 30,
            ),
            _inputField("Contraseña", passController, isPassword: true),
            const SizedBox(
              height: 30,
            ),
            _loginbtn(context),
            const SizedBox(
              height: 30,
            ),
            _extratext(context),
            const SizedBox(
              height: 30,
            ),
            _btnuser(context),
            const SizedBox(
              height: 30,
            ),
            _extratext2(context),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hinText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color.fromARGB(255, 51, 130, 248)),
    );
    return TextField(
      style: const TextStyle(
        color: Color.fromARGB(255, 49, 128, 247),
      ),
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      decoration: InputDecoration(
        hintText: hinText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 51, 127, 240),
        ),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _inputField2(String hinText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color.fromARGB(255, 50, 127, 243)),
    );
    return TextField(
      style: const TextStyle(
        color: Color.fromARGB(255, 52, 126, 236),
      ),
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      decoration: InputDecoration(
        hintText: hinText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 44, 120, 235),
        ),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _loginbtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("User : ${userController.text}");
        debugPrint("Pass : ${passController.text}");

        String user = userController.text;
        String pass = passController.text;

        if (user != '' && pass != '') {
          _login(context);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'ADVENTENCIA',
                  style: TextStyle(color: Color.fromARGB(255, 41, 124, 248)),
                ),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'VERIFIQUE SU USUARIO',
                        style: TextStyle(
                            fontSize: 18, color: Color.fromARGB(255, 51, 125, 235)),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 47, 124, 240),
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
        userController.text = '';
        passController.text = '';
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 69, 139, 245),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: 350,
        child: Text(
          'INICIAR SESION',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _btnuser(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pushNamed(context, '/user');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 49, 127, 243),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: 350,
        child: Text(
          'CREA NUEVO USUARIO',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> canempresa(BuildContext context) async {
    bool clientes = await funciones.conteodeempresa();
    if (clientes == true) {
      Navigator.pushNamed(context, '/registrar');
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'ADVENTENCIA',
              style: TextStyle(color: Color.fromARGB(255, 56, 130, 240)),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'SU EMPRESA YA EXISTE',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 50, 127, 243)),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 57, 133, 247),
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
  }

  Widget _extratext(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        canempresa(context);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 56, 133, 248),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: 350,
        child: Text(
          'REGISTRE SU EMPRESA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _extratext2(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/licencia');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 53, 126, 235),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
        width: 350,
        child: Text(
          'OBTENER LICENCIA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  

}
