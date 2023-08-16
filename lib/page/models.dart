import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  int? id;
  String username;
  String password;
  String ruc;
  String fechareg;
  String fechafinal;

  User(
      {this.id,
      required this.username,
      required this.password,
      required this.ruc,
      required this.fechareg,
      required this.fechafinal});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'ruc': ruc,
      'fechareg': fechareg,
      'fechafinal': fechafinal
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      ruc: map['ruc'],
      fechareg: map['fechareg'],
      fechafinal: map['fechafinal'],
    );
  }
}

class Datosusuario {
  int? id;
  String nombres;
  String correo;
  String telefono;
  String ruc;
  String razonsocial;
  String pais;
  String direccion;
  String fecharegistro;
  int nlicenciafree;
  int nlicenciaanual;

  Datosusuario(
      {this.id,
      required this.nombres,
      required this.correo,
      required this.telefono,
      required this.ruc,
      required this.razonsocial,
      required this.pais,
      required this.direccion,
      required this.fecharegistro,
      required this.nlicenciafree,
      required this.nlicenciaanual});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'usuario': correo,
      'telefono': telefono,
      'ruc': ruc,
      'razonsocial': razonsocial,
      'pais': pais,
      'direccion': direccion,
      'fecha': fecharegistro,
      'nlicenciafree': nlicenciafree,
      'nlicenciaanual': nlicenciaanual
    };
  }

  factory Datosusuario.fromMap(Map<String, dynamic> map) {
    return Datosusuario(
      id: map['id'],
      nombres: map['nombres'],
      correo: map['usuario'],
      telefono: map['telefono'],
      ruc: map['ruc'],
      razonsocial: map['razonsocial'],
      pais: map['pais'],
      direccion: map['direccion'],
      fecharegistro: map['fecharegistro'],
      nlicenciafree: map['nlicenciafree'],
      nlicenciaanual: map['nlicenciaanual'],
    );
  }
}

class Licencia {
  late int estado;
  late String licencia;

  Licencia({required int estado, required String licencia});
  Map<String, dynamic> toMap() {
    return {'estado': estado, 'licencia': licencia};
  }

  factory Licencia.fromMap(Map<String, dynamic> map) {
    return Licencia(
      estado: map['estado'],
      licencia: map['licencia'],
    );
  }
}

class SQLlogin {
  static Database? _dblogin;
  Future<Database?> get dblogin async {
    if (_dblogin == null) {
      _dblogin = await iniciarbaselogin();
      await insertlicencia();
      return _dblogin;
    } else {
      return _dblogin;
    }
  }

  Future<Database> iniciarbaselogin() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "usuarios.db");
    Database mylogin =
        await openDatabase(path, onCreate: _createDB, version: 1);
    return mylogin;
  }

  _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS clientes(id INTEGER PRIMARY KEY AUTOINCREMENT, nombres TEXT, usuario TEXT, telefono TEXT, ruc TEXT, razonsocial TEXT, pais TEXT, direccion TEXT, departamento TEXT, fecha TEXT, nlicenciafree INTEGER, nlicenciaanual INTEGER)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS licencia_free(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, ruc TEXT, fechareg TEXT, fechafinal TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS licencia_anual(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, ruc TEXT, fechareg TEXT, fechafinal TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS licencia(estado REAL, licencia TEXT)');
    debugPrint("se crearon la base de datos y las tablas");
  }

  Future<bool> getLicencia(String licencia) async {
    Database? mylogin = await dblogin;
    int estado = 1;
    final map = await mylogin!.query(
      'licencia',
      where: 'estado = ? AND licencia = ?',
      whereArgs: [estado, licencia],
      limit: 1,
    );
    if (map.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> actualizarlicencia(String anual) async {
    Database? mylogin = await dblogin;
    int estado = 2;
    await mylogin!.rawUpdate(
        'UPDATE licencia SET estado = ? WHERE licencia = ?', [estado, anual]);
  }

  Future<void> actualizarusuario(String user) async {
    Database? mylogin = await dblogin;
    final DateTime hoy = DateTime.now();
    //final String fechaActual = DateFormat('yyyy-MM-dd').format(hoy);
    final future = hoy.add(const Duration(days: 366));
    final String fin = DateFormat('yyyy-MM-dd').format(future);
    await mylogin!.rawUpdate(
        'UPDATE licencia_anual SET fechafinal = ? WHERE username = ?',
        [fin, user]);
  }

  Future<void> insertlicencia() async {
    Database? mylogin = await dblogin;

    bool isDataExist = await checkLicenciaExist(mylogin!);

    if (!isDataExist) {
      await mylogin.rawInsert(
          '''INSERT INTO licencia (estado, licencia) VALUES 
      (1,'ASDN28112NJN23HFIWS02'),
      (1,'1923NASD091NSD1123DS2'),
      (1,'DM129304SNDA0ASOKD12H'),
      (1,'JIJ1022394USDU1NBAV0X'),
      (1,'1J241923DJFDSNWSASD23'),
      (1,'SDIFJLKF99Q34NDS0F0AS'),
      (1,'MSAD9U01U2039120SDIFH'),
      (1,'ASD1823JFD9USF21O3ASD'),
      (1,'SJDF9124N3NCOV0SDLA9U'),
      (1,'MLASD9DN234KN0FD2348F'),
      (1,'03FSD0F0790FDS0UFQ3NI'),
      (1,'KASDI10824083Y2934NSD'),
      (1,'FOSIDNFO0293400FD82H0'),
      (1,'ASDNAUSDIUASIDUQUWHQI'),
      (1,'DASNDOIUS918W98112SAJ'),
      (1,'ASDNOAUISHFUDGDBSFN23'),
      (1,'ASD8H108H918BF8SHV9MA'),
      (1,'PDAMSDPIJ102J41F8DS0D'),
      (1,'DKANSODI109823012BVPU'),
      (1,'QKWNEOQ01U23081HLKJFN')
      ''');
      debugPrint("Se insertaron las licencias");
    } else {
      debugPrint("Las licencias ya están insertadas");
    }
  }

  Future<bool> checkLicenciaExist(Database mylogin) async {
    List<Map> result = await mylogin.query('licencia');
    return result.isNotEmpty;
  }

  Future<void> insertUser(User user) async {
    Database? mylogin = await dblogin;
    await mylogin!.insert('licencia_free', user.toMap());
  }

  Future<void> insertUser2(User user) async {
    Database? mylogin = await dblogin;
    await mylogin!.insert('licencia_anual', user.toMap());
  }

  Future<void> insertClientes(Datosusuario clientes) async {
    Database? mylogin = await dblogin;
    await mylogin!.insert('clientes', clientes.toMap());
  }

  Future<bool> buscarUsuariofree(String username, String password) async {
    Database? mylogin = await dblogin;

    final maps = await mylogin!.query(
      'licencia_free',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> buscarUsuarioanual(String username, String password) async {
    Database? mylogin = await dblogin;
    final maps = await mylogin!.query(
      'licencia_anual',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> compararCantidadLicencias() async {
    Database? mylogin = await dblogin;
    int? cantidadRegistrosLicenciaFree = await mylogin!
        .rawQuery('SELECT COUNT(*) FROM licencia_free')
        .then((value) => Sqflite.firstIntValue(value));
    int? cantidadUsuariosClientes = await mylogin
        .rawQuery('SELECT nlicenciafree FROM clientes')
        .then((value) => Sqflite.firstIntValue(value));
    if (cantidadRegistrosLicenciaFree! < cantidadUsuariosClientes!) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> compararCantidadLicencias2() async {
    Database? mylogin = await dblogin;
    int? cantidadRegistrosLicenciaAnual = await mylogin!
        .rawQuery('SELECT COUNT(*) FROM licencia_anual')
        .then((value) => Sqflite.firstIntValue(value));
    int? cantidadUsuariosClientes = await mylogin
        .rawQuery('SELECT nlicenciaanual FROM clientes')
        .then((value) => Sqflite.firstIntValue(value));
    if (cantidadRegistrosLicenciaAnual! < cantidadUsuariosClientes!) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> compararFechaFinalfree(String username) async {
    Database? mylogin = await dblogin;
    DateTime fechaActual = DateTime.now();
    final maps = await mylogin!.rawQuery(
        'SELECT fechafinal FROM licencia_free WHERE username = ?', [username]);
    if (maps.isNotEmpty) {
      String fechaGuardada = maps[0]['fechafinal'].toString();
      DateTime fechaFinal = DateFormat('yyyy-MM-dd').parse(fechaGuardada);
      if (fechaActual.isBefore(fechaFinal)) {
        return true;
      }
    }
    return false;
  }

  Future<bool> compararFechaFinalanual(String username) async {
    Database? mylogin = await dblogin;
    DateTime fechaActual = DateTime.now();
    final maps = await mylogin!.rawQuery(
        'SELECT fechafinal FROM licencia_anual WHERE username = ?', [username]);
    if (maps.isNotEmpty) {
      String fechaGuardada = maps[0]['fechafinal'].toString();
      DateTime fechaFinal = DateFormat('yyyy-MM-dd').parse(fechaGuardada);
      if (fechaActual.isBefore(fechaFinal)) {
        return true;
      }
    }
    return false;
  }

  Future<bool> veriruc(String ruc) async {
    Database? mylogin = await dblogin;
    final maps = await mylogin!.query(
      'clientes',
      where: 'ruc = ?',
      whereArgs: [ruc],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> conteodeempresa() async {
    Database? mylogin = await dblogin;
    int? cantidadempresa = await mylogin!
        .rawQuery('SELECT COUNT(*) FROM clientes')
        .then((value) => Sqflite.firstIntValue(value));
    if (cantidadempresa! < 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map>> getDatausuarios(String sql) async {
    Database? mylogin = await dblogin;
    List<Map> rep = await mylogin!.rawQuery(sql);
    return rep;
  }

  Future<int> getdelete(String sql) async {
    Database? mylogin = await dblogin;
    int rep = await mylogin!.rawDelete(sql);
    return rep;
  }
}
