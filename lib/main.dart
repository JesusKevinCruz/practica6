import 'package:flutter/material.dart';
import './database/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD de Usuarios',
      home: PantallaUsuarios(),
    );
  }
}

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  final AyudanteDB _ayudanteDB = AyudanteDB();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  List<Map<String, dynamic>> _usuarios = [];

  Future<void> _listarUsuarios() async {
    final usuarios = await _ayudanteDB.obtenerUsuarios();
    setState(() {
      _usuarios = usuarios;
    });
  }

  Future<void> _agregarUsuario() async {
    final nombre = _nombreController.text.trim();
    final edad = int.tryParse(_edadController.text.trim()) ?? 0;

    if (nombre.isNotEmpty && edad > 0) {
      await _ayudanteDB.insertarUsuario(nombre, edad);
      _nombreController.clear();
      _edadController.clear();
      _listarUsuarios();
    }
  }

  Future<void> _editarUsuario(int id) async {
    final nombre = _nombreController.text.trim();
    final edad = int.tryParse(_edadController.text.trim()) ?? 0;

    if (nombre.isNotEmpty && edad > 0) {
      await _ayudanteDB.actualizarUsuario(id, nombre, edad);
      _nombreController.clear();
      _edadController.clear();
      _listarUsuarios();
    }
  }

  Future<void> _eliminarUsuario(int id) async {
    await _ayudanteDB.eliminarUsuario(id);
    _listarUsuarios();
  }

  @override
  void initState() {
    super.initState();
    _listarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD de Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _agregarUsuario,
              child: const Text('Agregar Usuario'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _usuarios[index];
                  return Card(
                    child: ListTile(
                      title: Text(usuario['nombre']),
                      subtitle: Text('Edad: ${usuario['edad']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _nombreController.text = usuario['nombre'];
                              _edadController.text = usuario['edad'].toString();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Editar Usuario'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _nombreController,
                                          decoration: const InputDecoration(
                                              labelText: 'Nombre'),
                                        ),
                                        TextField(
                                          controller: _edadController,
                                          decoration: const InputDecoration(
                                              labelText: 'Edad'),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _editarUsuario(usuario['id']);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Guardar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarUsuario(usuario['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
