import 'dart:io';

import 'package:contabiliza_app/models/entidad_contable.dart';
import 'package:contabiliza_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EntidadContable> entidadesContables = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('entidades-contables', (payload) {
      //se debe de castear el payload a List para poder usar el metodo map
      entidadesContables = (payload as List)
          .map((entidad) => EntidadContable.fromJson(entidad))
          .toList();
      setState(() {});
    });

    super.initState();
  }

// para evitar que se quede escuchando el evento, se debe destruir el listener
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('entidades-contables');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Contabiliza App',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Conectado
                  ? const Icon(
                      Icons.wifi,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.wifi_off,
                      color: Colors.red,
                    ),
            )
          ],
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(entidadContable.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.socket.emit('eliminar-entidad', {
          'id': entidadContable.id,
        });
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
            socketService.socket.emit('incrementar-entidad', {
              'id': entidadContable.id,
            });
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket
          .emit('agregar-entidad', {'descripcion': descripcion});
    }

// esto es para cerrar el dialogo, el context es el contexto de la pantalla
    Navigator.of(context).pop();
  }

  // Widget _mostrarGrafica() {
  //   Map<String, double> dataMap = Map();

  //   for (var entidad in entidadesContables) {
  //     dataMap.putIfAbsent(
  //         entidad.descripcion, () => entidad.cantidad.toDouble());
  //     print(dataMap);
  //   }

  //   return SizedBox(
  //       width: double.infinity,
  //       height: 165,
  //       child: PieChart(
  //         dataMap: dataMap,
  //         chartType: ChartType.ring,
  //       ));
  // }
}
