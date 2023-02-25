import 'package:flutter/foundation.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/metodos_auxiliares.dart';
import 'package:http/http.dart' as http;

class PassarLinkVideo {
  static passarLink(linkVideo) async {
    String root = await MetodosAuxiliares.pegarIpMaquina();

    String endereco = "$root${Constantes.parametroBackPassarLinkVideo}";
    final Uri link = Uri.parse(endereco);
    try {
      final respostaRequisicao =  await http.post(link, body: {
        Constantes.parametroBackLinkVideo: linkVideo
      }).timeout(const Duration(seconds: 20));
      print(respostaRequisicao.body.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
