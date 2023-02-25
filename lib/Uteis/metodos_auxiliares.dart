import 'dart:io';

import 'package:senturionlettersg/Uteis/constantes.dart';

class MetodosAuxiliares {
  static dividirLetraEstrofes(List<String> letraCompleta) {
    List<String> letraCompletaCortada = [];
    for (var element in letraCompleta) {
      var corte = element.split("<br>");
      String versoConcatenado = "";
      for (int index = 0; index < corte.length; index++) {
        versoConcatenado =
        "$versoConcatenado ${Constantes.stringPularLinhaSlide} ${corte
            .elementAt(index)}";

        // verificando se index da lista e igual a algum dos valores passados para adicionar
        // string na outra lista pegando 2 linhas por vez lembrando 0 conta
        //print("s@${corte.elementAt(index)}");
        //print("#$versoConcatenado");
        if (index == 1 ||
            index == 3 ||
            index == 5 ||
            index == 7 ||
            index == 9 ||
            index == 11 ||
            index == 13 ||
            index == 15 ||
            index == 17 ||
            index == 19 ||
            index == 21 ||
            index == 23 ||
            index == 25 ||
            index == 27 ||
            index == 29 ||
            index == 31 ||
            index == 33 ||
            index == 35 ||
            index == 37 ||
            index == 39 ||
            index == 41) {
          letraCompletaCortada.add(versoConcatenado);
          versoConcatenado = "";
        } else if (index == corte.length - 1) {
          letraCompletaCortada.add(versoConcatenado);
          versoConcatenado = "";
        }
      }
    }
    return letraCompletaCortada;
  }

  // metodo para verificar o tipo de dispositivo que esta sendo
  //executado o programa
  static verificarTipoDispositivo() {
    // usado para definir tamanhos de iten
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static pegarIpMaquina() async {
    String ip = "";
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        ip = addr.address;
      }
    }
    ip = "http://$ip:5000";
    print(ip);
    return ip;
  }
}
