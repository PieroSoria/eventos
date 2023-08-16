// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Invitados1 {
  double id;
  String codigo;
  String documento;
  String nombre;
  String evento;
  String zona;

  Invitados1(
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.nombre,
      required this.evento,
      required this.zona});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'documento': documento,
      'nombre': nombre,
      'evento': evento,
      'zona': zona,
    };
  }

  factory Invitados1.fromMap(Map<String, dynamic> map) {
    return Invitados1(
        id: map['id'],
        documento: map['documento'],
        codigo: map['codigo'],
        nombre: map['nombre'],
        evento: map['evento'],
        zona: map['zona']);
  }
}

class Eventos {
  double id;
  String nombre;
  String estado;

  Eventos({required this.id, required this.nombre, required this.estado});
  Map<String, dynamic> toMap3() {
    return {'id': id, 'nombre': nombre, 'estado': estado};
  }

  factory Eventos.fromMap(Map<String, dynamic> map) {
    return Eventos(id: map['id'], nombre: map['nombre'], estado: map['estado']);
  }
}

class Resultados {
  double id;
  String codigo;
  String documento;
  String nombre;
  String evento;
  String zona;
  String ingreso;
  String salidas;
  Resultados(
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.nombre,
      required this.evento,
      required this.zona,
      required this.ingreso,
      required this.salidas});
  Map<String, dynamic> toMap2() {
    return {
      'id': id,
      'codigo': codigo,
      'documento': documento,
      'nombre': nombre,
      'evento': evento,
      'zona': zona,
      'ingreso': ingreso,
      'salida': salidas,
    };
  }

  factory Resultados.fromMap(Map<String, dynamic> map2) {
    return Resultados(
        id: map2['id'],
        codigo: map2['codigo'],
        documento: map2['documento'],
        nombre: map2['nombre'],
        evento: map2['evento'],
        zona: map2['zona'],
        ingreso: map2['ingreso'],
        salidas: map2['salida']);
  }
}

class SQLdb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialisation();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialisation() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "productos.db");
    Database mydb = await openDatabase(path, onCreate: _createDB, version: 1);
    return mydb;
  }

  _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS eventos (id REAL PRIMARY KEY, nombre TEXT, estado TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS zonas (id REAL PRIMARY KEY, nombre TEXT, estado TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS invitados (id REAL PRIMARY KEY,codigo TEXT, documento TEXT,nombre TEXT, evento TEXT, zona TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS resultados (id REAL PRIMARY KEY, codigo TEXT, documento TEXT,nombre TEXT, evento TEXT, zona TEXT, ingreso TEXT, salida TEXT) ');
    debugPrint(
        "==================base de datos creada =======================");
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawInsert(sql);
    return rep;
  }

  Future<void> insertevento(Eventos eventos) async {
    Database? mydb = await db;
    await mydb!.insert('eventos', eventos.toMap3());
  }

  Future<void> insertarzona(Eventos eventos) async {
    Database? mydb = await db;
    await mydb!.insert('zonas', eventos.toMap3());
  }

  Future<void> insertinvitados(Invitados1 invitados) async {
    final SQLdb sqLdb = SQLdb();
    Database? mydb = await sqLdb.db;
    await mydb!.insert('invitados', invitados.toMap());
  }

  Future<void> insertarResultados(Resultados result) async {
    final SQLdb sqLdb = SQLdb();
    Database? mydb = await sqLdb.db;
    await mydb!.insert('resultados', result.toMap2());
  }

  Future<List<Map>> getData(String sql) async {
    Database? mydb = await db;
    List<Map> rep = await mydb!.rawQuery(sql);
    return rep;
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<double> getNext() async {
    Database? mydb = await db;
    final List<Map<String, dynamic>> result = await mydb!.query(
      'resultados',
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      final double lastId = result[0]['id'];
      return lastId + 1;
    } else {
      return 1;
    }
  }

  Future<double> getNext2() async {
    Database? mydb = await db;
    final List<Map<String, dynamic>> result = await mydb!.query(
      'invitados',
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      final double lastId = result[0]['id'];
      return lastId + 1;
    } else {
      return 1;
    }
  }

  Future<double> getNext3() async {
    Database? mydb = await db;
    final List<Map<String, dynamic>> result = await mydb!.query(
      'eventos',
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      final double lastId = result[0]['id'];
      return lastId + 1;
    } else {
      return 1;
    }
  }

  Future<double> getNext4() async {
    Database? mydb = await db;
    final List<Map<String, dynamic>> result = await mydb!.query(
      'zonas',
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      final double lastId = result[0]['id'];
      return lastId + 1;
    } else {
      return 1;
    }
  }

  Future<List<String>> captureData() async {
    final SQLdb sqLdb = SQLdb();
    Database? mydb = await sqLdb.db;
    List<Map> result = await mydb!.query('eventos', columns: ['nombre']);
    List<String> nombres = [];
    nombres.add("SELECCIONAR EVENTO");
    for (var item in result) {
      nombres.add(item['nombre']);
    }
    return nombres;
  }

  Future<List<String>> captureData2() async {
    final SQLdb sqLdb = SQLdb();
    Database? mydb = await sqLdb.db;
    List<Map> result = await mydb!.query('zonas', columns: ['nombre']);
    List<String> nombres = [];
    nombres.add("SELECCIONAR ZONA");
    for (var item in result) {
      nombres.add(item['nombre']);
    }
    return nombres;
  }

  Future<String?> obtenerNombreInventarioActivo() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT basedatos FROM inventarios WHERE activo = 'ABIERTO' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['basedatos'] as String?;
    }
    return null;
  }

  Future<String?> obtenerbasedatos(String tablanombre) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT basedatos FROM inventarios WHERE nombre = '$tablanombre' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['basedatos'] as String?;
    }
    return null;
  }

  Future<String?> obtenerstock(String tabla, String codbarra) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT stock_inicial FROM $tabla WHERE codbarra = '$codbarra' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['stock_inicial'] as String?;
    }
    return null;
  }

  Future<String?> obtenerconteo(String tabla, String codbarra) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT conteo FROM $tabla WHERE codbarra = '$codbarra' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['conteo'] as String?;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query,
      [List<dynamic>? arguments]) async {
    Database? mydb = await db;
    return mydb!.rawQuery(query, arguments);
  }

  Future<bool> datoactivo(String codigo) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> rows = await mydb!
        .rawQuery("SELECT * FROM invitados WHERE codigo = '$codigo'");
    if(rows.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }
  Future<bool> isCodigoExistente(String codigo) async {
    Database? mydb = await db;
    var result = await mydb!.query(
      'invitados',
      where: 'codigo = ?',
      whereArgs: [codigo],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return true;
    }else{
      return false;
    }
  }
}
