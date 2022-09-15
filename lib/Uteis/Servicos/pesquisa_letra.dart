import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

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
    } catch (e) {
      debugPrint(e.toString());
    }
    return letraCortada;
  }

  static Future<String> exibirTituloLetra() async {
    return tituloLetra;
  }

  // future para pesquisar no google o que for digitado
  // pelo usuario e retornar somente os links para
  static Future pesquisarLinks(String itemDigitado) async {
    dynamic linkVerificar = "";
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
      //verificando todas as tag <a que existem na pagina html
      List<String> links = [];
      for (int i = 0;
          i < retornoResposta.getElementsByTagName("a").length;
          i++) {
        linkVerificar = retornoResposta.getElementsByTagName("a")[i].outerHtml;
        if (linkVerificar.toString().contains("www.letras.mus.br")) {
          //a variavel vai receber os valores que estao entre os parametros passados para o SUB STRING
          // o primeiro parametro do SUB STRING e para remover o comeco da tag <a deixando somente o link
          var resultadoLink =
              retornoResposta.getElementsByTagName("a")[i].outerHtml;
          links.add(resultadoLink);
          //print(links);
        }
      }
      return links;
    } catch (e) {
      List<String> retornoErro = [];
      return retornoErro;
    }
  }
}
