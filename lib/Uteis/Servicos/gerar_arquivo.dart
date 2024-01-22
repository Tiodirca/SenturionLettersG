import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/metodos_auxiliares.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../constantes.dart';
import 'package:flutter/foundation.dart';

class GerarArquivo {
  Future<String> passarValoresGerarArquivo(
      List<dynamic> letraCompleta, String tipoModelo, String nomeLetra) async {
    String root = await MetodosAuxiliares.pegarIpMaquina();
    String endereco = "$root${Constantes.parametroBackPegarValores}";

    var url = Uri.parse(endereco);
    try {
      // criando map para adicionar os valores da lista
      Map<String, String> dadosBackEnd = {};
      // add cada elemento da lista no map
      for (int i = 0; i < letraCompleta.length; i++) {
        // a chave deve ser a mesma utilizada na back end em python
        dadosBackEnd
            .addAll({"versos[$i]": letraCompleta[i].substring(5).toString()});
      }
      print(dadosBackEnd.values.toString());
      // add elemento contendo o tamanho do map criado com os elementos da lista
      dadosBackEnd.addAll({"tamanho_lista": dadosBackEnd.length.toString()});
      dadosBackEnd.addAll({"modelo_slide": tipoModelo.toString()});
      dadosBackEnd.addAll({"nome_letra": nomeLetra});
      // variavel vai receber o retorno da requisicao http
      final respostaRequisicao = await http
          .post(url, body: dadosBackEnd)
          .timeout(const Duration(seconds: 20));

      if (respostaRequisicao.body
          .contains(Constantes.retornoRequesicaoSucesso)) {
        abrirNavegador(nomeLetra);
        dadosBackEnd = {};
        return respostaRequisicao.body.toString();
      } else {
        return respostaRequisicao.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  // future responsavel por abrir o navegador
  Future<void> abrirNavegador(String nomeLetra) async {
    String root = await MetodosAuxiliares.pegarIpMaquina();

    String endereco = "$root${Constantes.parametroBackChamarBaixarArquivo}";
    final Uri url = Uri.parse(endereco);
    if (await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    )) {
      // definindo timer para executar comando apos determinado tempo
      Timer(const Duration(seconds: 2), () async {
        excluirArquivoDoBackEnd(nomeLetra);
      });
    } else {
      throw 'Could not launch $url';
    }
  }

// metodo para excluir o arquivo criado na pasta do
// back end que cria o arquivo de slides
  excluirArquivoDoBackEnd(nomeLetra) async {
    String root = await MetodosAuxiliares.pegarIpMaquina();
    String endereco = "$root${Constantes.parametroBackExcluirArquivo}";
    final Uri linkExcluirArquivo = Uri.parse(endereco);
    try {
      await http.post(linkExcluirArquivo,
          body: {'arquivo': nomeLetra}).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
