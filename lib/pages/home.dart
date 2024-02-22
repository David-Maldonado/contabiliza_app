import 'dart:io';

import 'package:contabiliza_app/models/entidad_contable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EntidadContable> entidadesContables = [
    EntidadContable(id: '1', descripcion: 'Caja', cantidad: 100),
    EntidadContable(id: '2', descripcion: 'Banco', cantidad: 200),
    EntidadContable(id: '3', descripcion: 'Clientes', cantidad: 300),
    EntidadContable(id: '4', descripcion: 'Proveedores', cantidad: 400),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contabiliza App',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: ListView.builder(
            itemCount: entidadesContables.length,
            itemBuilder: (BuildContext context, int index) {
              return _entidadContableTitle(entidadesContables[index]);
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewEntidadContable,
          elevation: 1,
          child: const Icon(Icons.add),
        ));
  }

  Widget _entidadContableTitle(EntidadContable entidadContable) {
    return Dismissible(
      key: Key(entidadContable.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('eliminado $direction');
        print(entidadContable.descripcion);
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo,
            child: Text(
              entidadContable.descripcion.substring(0, 2),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(entidadContable.descripcion),
          trailing: Text(
            '${entidadContable.cantidad}',
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () {
            print(entidadContable.descripcion);
          }),
    );
  }

  addNewEntidadContable() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Agregar entidad a contabilizar'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                    elevation: 5,
                    textColor: Colors.indigo,
                    onPressed: () =>
                        addNewEntidadContableList(textController.text),
                    child: const Text('Agregar'))
              ],
            );
          });
    }

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Agregar entidad a contabilizar'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => addNewEntidadContableList(textController.text),
                isDefaultAction: true,
                child: const Text('Agregar'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ],
          );
        });
  }

  void addNewEntidadContableList(String descripcion) {
    if (descripcion.isNotEmpty) {
      final newEntidadContable = EntidadContable(
          id: DateTime.now().toString(), descripcion: descripcion, cantidad: 0);
      setState(() {
        entidadesContables.add(newEntidadContable);
      });
    }

// esto es para cerrar el dialogo, el context es el contexto de la pantalla
    Navigator.of(context).pop();
  }
}
