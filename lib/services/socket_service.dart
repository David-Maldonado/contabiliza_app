import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: constant_identifier_names
enum ServerStatus { Conectado, Desconectado, Conectando }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conectado;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('https://contabiliza-server.vercel.app/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Conectado;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Desconectado;
      notifyListeners();
    });

    _socket.on('error', (error) {
      print('Error de conexión: $error');
      // Manejar el error de conexión aquí, si es necesario
    });
  }
}
