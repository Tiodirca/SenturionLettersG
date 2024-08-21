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
            "$versoConcatenado ${Constantes.stringPularLinhaSlide} ${corte.elementAt(index)}";
        // verificando se index da lista e igual a algum dos valores passados para adicionar
        // string na outra lista pegando 2 linhas por vez lembrando 0 conta
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
            index == 41 ||
            index == 43 ||
            index == 45 ||
            index == 47 ||
            index == 49 ||
            index == 51 ||
            index == 53 ||
            index == 55 ||
            index == 57 ||
            index == 59 ||
            index == 61 ||
            index == 63 ||
            index == 65 ||
            index == 67 ||
            index == 69 ||
            index == 71 ||
            index == 73 ||
            index == 75 ||
            index == 77 ||
            index == 79 ||
            index == 81 ||
            index == 83 ||
            index == 85 ||
            index == 87 ||
            index == 89 ||
            index == 91 ||
            index == 93 ||
            index == 95 ||
            index == 97 ||
            index == 99 ||
            index == 101 ||
            index == 103 ||
            index == 105 ||
            index == 107 ||
            index == 109) {
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
    //print(ip);
    return ip;
  }
}
