import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:senturionlettersg/Uteis/constantes.dart';

class PesquisaLetra {
  static String tituloLetra = "";

  static Future<List<String>> pesquisarLetra(String linkLetra) async {
    var root = Uri.parse(linkLetra);
    List<String> letraCortada = [];
    try {
      final response =
          await http.get(root).timeout(const Duration(seconds: 20));
      var document = parse(response.body);
      //for para pegar todos os indexs
      for (int i = 0;
          i < document.getElementsByClassName("cnt-letra p402_premium").length;
          i++) {
        //pegando o titulo e cantores da musica da musica apartir dos parametros passados para o SUB STRING
        //parametros passados para os GET ELEMENTS BY CLASS NAME pegados no site do letras.mus.com.br
        // usando o inspecionar
        var limiteTagTitulo = document
            .getElementsByClassName("cnt-head_title")[i]
            .outerHtml
            .lastIndexOf('/">');
        var resultadoTagTitulo = document
            .getElementsByClassName("cnt-head_title")[i]
            .outerHtml
            .substring(33, limiteTagTitulo);
        tituloLetra = resultadoTagTitulo
            .replaceAll(
                RegExp(
                  r'</h1> <h2> <a href="',
                ),
                '')
            .replaceAll(RegExp(r'[-,/]'), ' ');
        //pegando a letra completa apartir dos parametros passados para o SUB STRING
        var resultadoTagLetra = document
            .getElementsByClassName("cnt-letra p402_premium")[i]
            .outerHtml
            .substring(36);
        var letraCompleta = resultadoTagLetra.replaceAll(
            RegExp(
              r'</div>',
            ),
            '');
        letraCortada = letraCompleta.split("<p>");
      }
      return letraCortada;
    } catch (e) {
      debugPrint(e.toString());
      return [Constantes.msgErroPesquisaLetra];
    }
  }

  // future para retornar o titulo da letra da musica pesquisa
  static Future<String> exibirTituloLetra() async {
    return tituloLetra;
  }

  // future para pesquisar no google o que for digitado
  // pelo usuario e retorna um map contendo o titulo do link e o link
  // para direcionar a pagina
  static Future pesquisarLinks(String itemDigitado) async {
    var linkPesquisa =
        Uri.parse("https://www.google.com/search?q=$itemDigitado");
    try {
      final resposta = await http.get(
        linkPesquisa,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      ).timeout(const Duration(seconds: 20));
      var retornoResposta = parse(resposta.body);
      List<Map<String, String>> linksNome = [];
      // pegando os elementos da lista que estao dentro da TAG A(tag de link)
      retornoResposta.getElementsByTagName("a").forEach((elemento) {
        // pegando o conteudo contido dentro do item da lista
        String linksResposta = elemento.outerHtml;
        if (linksResposta.contains("www.letras.mus.br") &&
            // verificando se a varivavel contem nome da classe e o nome do site
            linksResposta.contains("BNeawe")) {
          Map<String, String> dados = {};
          //print(linksResposta);
          // variaveis vai receber String partindo da primeira ocorrencia
          // do primeiro INDEX OF e indo ate a primeira correncia do segundo INDEX OF
          String nomeLink = linksResposta.substring(
              linksResposta.indexOf('AP7Wnd">'),
              linksResposta.indexOf("</div>"));
          String link =
              linksResposta.substring(16, linksResposta.indexOf("/&amp"));
          //print(linksResposta.substring(16, linksResposta.indexOf("/&amp")));
          dados[nomeLink] = link;
          linksNome.add(dados);
        }
      });
      return linksNome;
    } catch (e) {
      List<String> retornoErro = [];
      return retornoErro;
    }
  }
}
