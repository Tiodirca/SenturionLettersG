import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:senturionlettersg/Uteis/constantes.dart';

class PesquisaLetra {
  static String tituloLetra = "";

  static Future<List<String>> pesquisarLetra(String linkLetra) async {
    if (linkLetra.contains("cifraclub")) {
      linkLetra = "$linkLetra/letra/";
    }
    var root = Uri.parse(linkLetra);
    List<String> letraCortada = [];
    try {
      final response =
          await http.get(root).timeout(const Duration(seconds: 20));
      var document = parse(response.body);
      String parametroClasseSiteLetra = "lyric-original";
      String parametroClasseNomeMusicaLetra = "textStyle-primary";
      String parametroClasseNomeCantorLetra = "textStyle-secondary";
      String parametroRemoverStringLetraNomeMusica =
          '<h1 class="textStyle-primary">';
      int parametroCorteNomeMusicaLetra = 37;

      String parametroClasseSiteCifra = "letra";
      String parametroClasseNomeMusicaCifra = "t1";
      String parametroClasseNomeCantorCifra = "t3";
      String parametroRemoverStringCifra = '<h1 class="t1">';
      int parametroCorteNomeMusicaCifra = 25;

      if (linkLetra.contains("m.letras.mus.br") ||
          linkLetra.contains("www.letras.mus.br")) {
        letraCortada = await pegarLetraCompleta(
            parametroClasseSiteLetra,
            parametroClasseNomeMusicaLetra,
            parametroClasseNomeCantorLetra,
            document,
            parametroCorteNomeMusicaLetra,
            parametroRemoverStringLetraNomeMusica);
      } else {
        letraCortada = await pegarLetraCompleta(
            parametroClasseSiteCifra,
            parametroClasseNomeMusicaCifra,
            parametroClasseNomeCantorCifra,
            document,
            parametroCorteNomeMusicaCifra,
            parametroRemoverStringCifra);
      }
      return letraCortada;
    } catch (e) {
      debugPrint(e.toString());
      return [Constantes.msgErroPesquisaLetra];
    }
  }

  static pegarLetraCompleta(
      String parametroLetra,
      String paremetroNomeMusica,
      String parametroNomeCantor,
      var document,
      int numeroCorte,
      String parametroReplace) async {
    tituloLetra = "";
    for (int i = 0;
        i < document.getElementsByClassName(parametroLetra).length;) {
      // definindo que as variaveis vao receber os valores
      // usando o getElement para pegar os valores dentro das classe
      // passada como parametros
      //print(document.getElementsByClassName(parametroLetra).toString());
      var nomeMusica =
          document.getElementsByClassName(paremetroNomeMusica)[i].outerHtml;
      nomeMusica = nomeMusica
          .toString()
          .replaceAll(parametroReplace, "")
          .toString()
          .replaceAll("</h1>", "")
          .replaceAll("\n", "")
          .replaceAll("  ", "");
      if (parametroLetra.contains("letra")) {
        var limiteTagNomeCantor = document
            .getElementsByClassName(parametroNomeCantor)[i]
            .outerHtml
            .lastIndexOf('/">');

        var resultadoTagNomeCantor = document
            .getElementsByClassName(parametroNomeCantor)[i]
            .outerHtml
            .substring(numeroCorte, limiteTagNomeCantor);
        tituloLetra = nomeMusica +
            " - " +
            resultadoTagNomeCantor.toString().replaceAll("-", " ");
      } else {
        String parametroReplaceSiteLetra = '<h2 class="textStyle-secondary">';
        var nomeCantor =
            document.getElementsByClassName(parametroNomeCantor)[i].outerHtml;
        nomeCantor = nomeCantor
            .toString()
            .replaceAll(parametroReplaceSiteLetra, "")
            .toString()
            .replaceAll("</h2>", "")
            .replaceAll("\n", "")
            .replaceAll("  ", "");
        tituloLetra = nomeMusica + " - " + nomeCantor;
      }
      //pegando a letra completa apartir dos
      // parametros passados para o SUB STRING
      // 23 pois corresponde ao numero de caracters <div class="cnt-letra">
      var resultadoTagLetra = document
          .getElementsByClassName(parametroLetra)[i]
          .outerHtml
          .substring(23);
      var letraCompleta = resultadoTagLetra.replaceAll(
          RegExp(
            r'</div>',
          ),
          '');
      return letraCompleta.split("<p>");
    }
  }

  // future para retornar o titulo
  // da letra da musica pesquisa
  static Future<String> exibirTituloLetra() async {
    return tituloLetra.replaceAll("/", "");
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
      //print("SF${resposta.body.toString()}");
      var retornoResposta = parse(resposta.body);
      //print("RS${retornoResposta.outerHtml}");
      print(retornoResposta.getElementsByClassName("MjjYud").toString());
      List<Map<String, String>> linksNome = [];
      //pegando os elementos da lista que estao dentro da TAG A(tag de link)
      retornoResposta.getElementsByTagName("a").forEach((elemento) {
        // pegando o conteudo contido dentro do item da lista
        String linksResposta = elemento.outerHtml;
        //print("LINKRS:${linksResposta.toString()}");
        //print("ELSe:${elemento.outerHtml}");
        if (linksResposta.contains("BNeawe")) {
          //print("LINK:${linksResposta.toString()}");
          //print("ELe:${elemento.outerHtml}");
        }
        if (linksResposta.contains("m.letras.mus.br") &&
                linksResposta.contains("BNeawe") ||
            linksResposta.contains("www.letras.mus.br") &&
                linksResposta.contains("BNeawe") ||
            linksResposta.contains("www.cifraclub.com.br")) {
          Map<String, String> dados = {};

          // variavel vai receber  uma string
          // partindo da primeira ocorrencia
          // do primeiro INDEX OF e indo ate a primeira
          // correncia do segundo INDEX OF
          String nomeLink = linksResposta.substring(
              linksResposta.indexOf('AP7Wnd">'),
              linksResposta.indexOf("</div>"));
          String link =
              linksResposta.substring(16, linksResposta.indexOf("/&amp"));
          dados[nomeLink] = link;
          linksNome.add(dados);
        }
      });
      return linksNome;
    } catch (e) {
      List<Map<String, String>> retornoErro = [];
      print("ERRO${e.toString()}");
      return retornoErro;
    }
  }
}
