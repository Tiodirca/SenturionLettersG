import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';

import 'Uteis/rotas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Constantes.rotaTelaInicial,
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}
