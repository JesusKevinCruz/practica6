import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AyudanteDB {
  static final AyudanteDB _instancia = AyudanteDB._interno();
  static Database? _baseDeDatos;

  factory AyudanteDB() {
    return _instancia;
  }

  AyudanteDB._interno();

  Future<Database> get baseDeDatos async {
    if (_baseDeDatos != null) return _baseDeDatos!;
    _baseDeDatos = await _inicializarDB();
    return _baseDeDatos!;
  }

  Future<Database> _inicializarDB() async {
    final rutaDB = await getDatabasesPath();
    final rutaCompleta = join(rutaDB, 'usuarios.db');

    return openDatabase(
      rutaCompleta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            edad INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertarUsuario(String nombre, int edad) async {
    final db = await baseDeDatos;
    return db.insert('usuarios', {'nombre': nombre, 'edad': edad});
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final db = await baseDeDatos;
    return db.query('usuarios');
  }

  Future<int> actualizarUsuario(int id, String nombre, int edad) async {
    final db = await baseDeDatos;
    return db.update(
      'usuarios',
      {'nombre': nombre, 'edad': edad},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> eliminarUsuario(int id) async {
    final db = await baseDeDatos;
    return db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
