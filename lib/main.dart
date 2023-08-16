import 'package:eventos/page/index.dart';
import 'package:eventos/page/loginpage.dart';
import 'package:eventos/page/registrar.dart';
import 'package:eventos/page/userruc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Map<String, WidgetBuilder> routes = {
    '/': (BuildContext context) => const LoginPage(),
    '/registrar': (BuildContext context) => const Registrar(),
    '/user': (BuildContext context) => const Userruc(),
    '/index': (BuildContext context) => const Index(user: ''),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Eventos',
      initialRoute: '/',
      routes: routes,
    );
  }
}

