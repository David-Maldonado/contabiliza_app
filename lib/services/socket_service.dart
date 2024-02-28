import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Conectado, Desconectado, Conectando }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conectando;
  final IO.Socket _socket = IO.io('http://192.168.100.128:3001', {
    'transports': ['websocket'],
    'autoConnect': true,
  });

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Conectado;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Desconectado;
      notifyListeners();
    });
  }
}
