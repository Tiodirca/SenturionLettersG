import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';

class Estilo {
  ThemeData get estiloGeral => ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,

        backgroundColor: PaletaCores.corAzulMagenta,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(
              fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(20),
          ),),


      // estilo dos botoes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,

          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: PaletaCores.corAzulMagenta,width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ));
}
