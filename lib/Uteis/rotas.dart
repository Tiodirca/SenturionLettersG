import 'package:flutter/material.dart';
import 'package:senturionlettersg/Telas/Listagem/tela_listagem_letra_unir.dart';
import 'package:senturionlettersg/Telas/tela_dividir_letra_texto.dart';
import 'package:senturionlettersg/Telas/tela_edicao_letra.dart';
import 'package:senturionlettersg/Telas/tela_inicial.dart';
import 'package:senturionlettersg/Telas/Listagem/tela_listagem_letra.dart';

import 'package:senturionlettersg/Telas/tela_pesquisa.dart';
import 'constantes.dart';

class Rotas {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recebe os parâmetros na chamada do Navigator.
    final args = settings.arguments;
    switch (settings.name) {
      case Constantes.rotaTelaInicial:
        return MaterialPageRoute(builder: (_) => TelaInicial());
      case Constantes.rotaTelaDividirLetraTexto:
        return MaterialPageRoute(builder: (_) => const TelaDividirLetraTexto());
      case Constantes.rotaTelaPesquisa:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => TelaPesquisa(
                    tipoPesquisa: args,
                  ));
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaListagemLetra:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaLisagemLetra(
              linkLetra: args[Constantes.parametrosTelaLinkLetra],
              parametroDividirLetraTexto:
                  args[Constantes.parametroTelaDividirLetraTexto],
              letraCompleta: args[Constantes.parametrosTelaLetra],
              nomeLetra: args[Constantes.parametrosTelaNomeLetra],
              modelo: args[Constantes.parametrosTelaModelo],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaListagemLetraUnir:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaListagemLetraUnir(
              linksLetrasUnirPesquisa: args[Constantes.parametrosTelaLinkLetra],
              letraEditada: args[Constantes.parametrosTelaLetraEditada],
              nomeLetraFinal: args[Constantes.parametrosTelaNomeLetra],
              tipoModelo: args[Constantes.parametrosTelaModelo],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaEdicaoLetra:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaEdicaoLetra(
              letraCompleta: args[Constantes.parametrosTelaLetra],
              nomeLetra: args[Constantes.parametrosTelaNomeLetra],
              tipoModelo: args[Constantes.parametrosTelaModelo],
              linksLetras: args[Constantes.parametrosTelaLinkLetra],
            ),
          );
        } else {
          return erroRota(settings);
        }
    }
    // Se o argumento não é do tipo correto, retorna erro
    return erroRota(settings);
  }

  //metodo para exibir tela de erro
  static Route<dynamic> erroRota(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Telas não encontrada!"),
        ),
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text("Erro de Rota"),
          ),
        ),
      );
    });
  }
}
