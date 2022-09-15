import 'package:flutter/material.dart';
import 'package:senturionlettersg/Telas/tela_inicial.dart';
import 'package:senturionlettersg/Telas/tela_listagem_letra.dart';
import 'package:senturionlettersg/Telas/tela_pesquisa.dart';
import '../Telas/tela_splash_screen.dart';
import 'constantes.dart';

class Rotas {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recebe os parâmetros na chamada do Navigator.
    final args = settings.arguments;
    switch (settings.name) {
      case Constantes.rotaTelaSplashScreen:
        return MaterialPageRoute(builder: (_) => const TelaSplashScreen());
      case Constantes.rotaTelaInicial:
        return MaterialPageRoute(builder: (_) => TelaInicial());
      case Constantes.rotaTelaPesquisa:
        return MaterialPageRoute(builder: (_) => const TelaPesquisa());
      case Constantes.rotaTelaListagemLetra:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => TelaLisagemLetra(
                linkMusica: args,
                  ));
        } else {
          return erroRota(settings);
        }
      // case Constantes.rotaTelaCadastroLocalTrabalho:
      //   if (args is Map) {
      //     return MaterialPageRoute(
      //       builder: (_) => TelaCadastroLocalTrabalho(
      //         genero: args[Constantes.parametroGenero],
      //         listaPessoas: args[Constantes.parametroListaPessoas],
      //       ),
      //     );
      //   } else {
      //     return erroRota(settings);
      //   }
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
            child: Text("Telas não encontrada."),
          ),
        ),
      );
    });
  }
}
