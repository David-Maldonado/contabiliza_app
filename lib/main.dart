import 'package:contabiliza_app/pages/status.dart';
import 'package:contabiliza_app/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:contabiliza_app/pages/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          //! si no se va a usar el buildContext, se puede usar el guion bajo
          'home': (_) => const HomePage(),
          'status': (_) => const StatusPage(),
        },
      ),
    );
  }
}
