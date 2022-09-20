import 'dart:io';

import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/Servicos/pesquisa_letra.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';
import 'package:senturionlettersg/widgets/tela_carregamento.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class TelaLisagemLetra extends StatefulWidget {
  const TelaLisagemLetra(
      {Key? key,
      required this.linkLetra,
      required this.letraCompleta,
      required this.nomeLetra,
      required this.modelo})
      : super(key: key);

  final String linkLetra;
  final List<String> letraCompleta;
  final String nomeLetra;
  final String modelo;

  @override
  State<TelaLisagemLetra> createState() => _TelaLisagemLetraState();
}

class _TelaLisagemLetraState extends State<TelaLisagemLetra> {
  Estilo estilo = Estilo();
  bool boolExibirTelaCarregamento = true;
  bool boolExibirBotoes = false;
  bool boolExibirLogo = false;
  late String tipoModelo = widget.modelo;
  int valorRadioButton = 0;
  String exibicaoTela = Constantes.exibicaoTelaCarregar;
  List<String> letraCompleta = [];
  List<String> letraCompletaCortada = [];
  String nomeLetra = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.linkLetra.isNotEmpty) {
      realizarPesquisaLetraCompleta(); // chamando metodo
    } else {
      letraCompletaCortada = widget.letraCompleta;
      nomeLetra = widget.nomeLetra;
      exibicaoTela = Constantes.exibicaoTelaListagemLetra;
      boolExibirBotoes = true;
      if (widget.modelo == Constantes.logoGeral) {
        boolExibirLogo = false;
      } else {
        boolExibirLogo = true;
      }
    }
  }

  // metodo responsavel por chamar metodo para realizar a pesquisa da letra completa
  realizarPesquisaLetraCompleta() async {
    await PesquisaLetra.pesquisarLetra(widget.linkLetra).then(
      (value) {
        letraCompleta = value;
        setState(() {
          //removendo primeiro index da lista pois o mesmo e vazio
          letraCompleta.removeAt(0);
          exibicaoTela = Constantes.exibicaoTelaSelecaoLogo;
          boolExibirTelaCarregamento = false;
        });
      },
    );

    for (var element in letraCompleta) {
      var corte = element.split("<br>");
      String versoConcatenado = "";
      for (int index = 0; index < corte.length; index++) {
        versoConcatenado =
            "$versoConcatenado ${Constantes.stringPularLinhaSlide} ${corte.elementAt(index)}";
        // vericficando se o index da lista e igual a algum dos valores passados para adicionar
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
            index == 19) {
          letraCompletaCortada.add(versoConcatenado);
          versoConcatenado = "";
        } else if (index == corte.length - 1) {
          letraCompletaCortada.add(versoConcatenado);
          versoConcatenado = "";
        }
      }
    }
    // variavel vai receber o valor retornado pelo metodo
    nomeLetra = await PesquisaLetra.exibirTituloLetra();
  }

  void mudarRadioButton(int value) {
    //metodo para mudar o estado do radio button
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            tipoModelo = Constantes.logoGeral;
            boolExibirLogo = false;
          });
          break;
        case 1:
          setState(() {
            tipoModelo = Constantes.logoGeracaoFire;
            boolExibirLogo = true;
          });
          break;
      }
    });
  }

  // future responsavel por abrir o navegador
  Future<void> abrirNavegador() async {
    String endereco = "http://192.168.69.105:5000/chamarBaixarArquivo";
    final Uri url = Uri.parse(endereco);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  // metodo para passar os valores para o back end
  // para assim estar gerando o arquivo
  Future<dynamic> passarValoresGerarArquivo() async {
    setState(() {
      exibicaoTela = Constantes.exibicaoTelaCarregar;
      boolExibirBotoes = false;
    });
    String endereco = "http://192.168.69.105:5000/pegarValores";
    var url = Uri.parse(endereco);
    try {
      // criando map para adicionar os valores da lista
      Map<String, String> dadosBackEnd = {};
      // add cada elemento da lista no map
      for (int i = 0; i < letraCompletaCortada.length; i++) {
        // a chave deve ser a mesma utilizada na back end em python
        dadosBackEnd.addAll(
            {"versos[$i]": letraCompletaCortada[i].substring(5).toString()});
      }
      // add elemento contendo o tamanho do map criado com os elementos da lista
      dadosBackEnd.addAll({"tamanhoLista": dadosBackEnd.length.toString()});
      dadosBackEnd.addAll({"modelo_slide": tipoModelo.toString()});
      dadosBackEnd.addAll({"nome_letra": nomeLetra});
      // variavel vai receber o retorno da requisicao http
      final respostaRequisicao = await http
          .post(url, body: dadosBackEnd)
          .timeout(const Duration(seconds: 20));

      if (respostaRequisicao.body.contains("sucesso")) {
        setState(() {
          exibicaoTela = Constantes.exibicaoTelaListagemLetra;
          boolExibirBotoes = true;
          dadosBackEnd = {};
        });
        abrirNavegador();
      } else {
        setState(() {
          exibicaoTela = Constantes.exibicaoTelaListagemLetra;
          boolExibirBotoes = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Textos.erroGerarArquivo + respostaRequisicao.body)));
      }
    } catch (e) {
      setState(() {
        exibicaoTela = Constantes.exibicaoTelaListagemLetra;
        boolExibirBotoes = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Textos.erroGerarArquivo + e.toString())));
      debugPrint(e.toString());
      return false;
    }
  }

  Widget listagemLetra(double larguraTela, double alturaTela,
          double tamanhoIcones, double tamanhoTexto, double tamanhoSlide) =>
      SizedBox(
        width: larguraTela,
        height: alturaTela * 0.6,
        child: ListView.builder(
          itemCount: letraCompletaCortada.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Container(
                    padding: const EdgeInsets.all(10),
                    width: larguraTela,
                    height: tamanhoSlide,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/imagens/fundo_letra.png'),
                            fit: BoxFit.cover)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: tamanhoIcones,
                                  height: tamanhoIcones,
                                  child: Visibility(
                                    visible: boolExibirLogo,
                                    child: Image.asset(
                                      'assets/imagens/logo_geracao_fire.png',
                                    ),
                                  )),
                              SizedBox(
                                width: larguraTela * 0.5,
                                child: Text(
                                  nomeLetra,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decorationStyle: TextDecorationStyle.solid,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: tamanhoIcones,
                                height: tamanhoIcones,
                                child: Image.asset(
                                  'assets/imagens/logo_adtl.png',
                                ),
                              ),
                            ],
                          ),
                          Text(
                              letraCompletaCortada[index]
                                  .substring(5)
                                  .toString()
                                  .replaceAll(
                                      RegExp(
                                        r'</p>',
                                      ),
                                      '')
                                  .replaceAll(
                                      RegExp(
                                        Constantes.stringPularLinhaSlide,
                                      ),
                                      '\n'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: tamanhoTexto,
                                color: Colors.white,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 10.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 10.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 10.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 10.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )));
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(Textos.telaVisualizacaoLetra),
            ),
            body: Container(
              margin: const EdgeInsets.only(right: 10.0, left: 10.0),
              width: larguraTela,
              height: alturaTela,
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (exibicaoTela == Constantes.exibicaoTelaCarregar) {
                    return SizedBox(
                        width: larguraTela,
                        height: alturaTela,
                        child: const Center(
                          child: TelaCarregamento(),
                        ));
                  } else if (exibicaoTela ==
                      Constantes.exibicaoTelaSelecaoLogo) {
                    return SizedBox(
                      width: larguraTela,
                      height: alturaTela,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
                            width: larguraTela,
                            child: Text(
                              Textos.descricaoSelecaoLogo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 30.0),
                            child: Wrap(
                              children: [
                                Card(
                                  elevation: 0,
                                  color: valorRadioButton == 0
                                      ? PaletaCores.corVerdeCiano
                                      : Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 300,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                            'assets/imagens/logo_adtl.png',
                                          ),
                                        ),
                                        Radio(
                                            activeColor:
                                                PaletaCores.corCastanho,
                                            value: 0,
                                            groupValue: valorRadioButton,
                                            onChanged: (_) {
                                              mudarRadioButton(0);
                                            }),
                                        Text(
                                          Textos.radioButtonGeral,
                                          style: TextStyle(
                                            color: valorRadioButton == 0
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  color: valorRadioButton == 1
                                      ? PaletaCores.corVerdeCiano
                                      : Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 300,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                            'assets/imagens/logo_geracao_fire.png',
                                          ),
                                        ),
                                        Radio(
                                            activeColor:
                                                PaletaCores.corCastanho,
                                            value: 1,
                                            groupValue: valorRadioButton,
                                            onChanged: (_) {
                                              mudarRadioButton(1);
                                            }),
                                        Text(
                                          Textos.radioButtonGeracaoFire,
                                          style: TextStyle(
                                            color: valorRadioButton == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PaletaCores.corVerdeCiano,
                              ),
                              onPressed: () {
                                setState(() {
                                  boolExibirBotoes = true;
                                  exibicaoTela =
                                      Constantes.exibicaoTelaListagemLetra;
                                });
                              },
                              child: Text(Textos.btnUsar,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 20.0),
                              width: larguraTela,
                              child: Text(
                                Textos.descricaoTelaVisualizacaoLetra,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                width: larguraTela,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      nomeLetra,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Quantidade de Slides : ${letraCompletaCortada.length}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )),
                            LayoutBuilder(
                              builder: (p0, p1) {
                                if (Platform.isAndroid || Platform.isIOS) {
                                  return listagemLetra(
                                      larguraTela, alturaTela, 35, 20, 200);
                                } else {
                                  return listagemLetra(larguraTela * 0.7,
                                      alturaTela, 50, 30, 200);
                                }
                              },
                            )
                          ],
                        ));
                  }
                },
              ),
            ),
            bottomNavigationBar: SizedBox(
                width: larguraTela,
                height: alturaTela * 0.1,
                child: Visibility(
                    visible: boolExibirBotoes,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: larguraTela,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PaletaCores.corCastanho,
                                ),
                                onPressed: () {
                                  Map dados = {};
                                  dados[Constantes.parametrosTelaLetra] =
                                      letraCompletaCortada;
                                  dados[Constantes.paramatrosTelaNomeLetra] =
                                      nomeLetra;
                                  dados[Constantes.parametrosTelaModelo] =
                                      tipoModelo;
                                  Navigator.pushReplacementNamed(
                                      context, Constantes.rotaTelaEdicaoLetra,
                                      arguments: dados);
                                },
                                child: Text(Textos.btnEditar,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              height: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PaletaCores.corVerdeCiano,
                                ),
                                onPressed: () {
                                  passarValoresGerarArquivo();
                                },
                                child: Text(Textos.btnGerarArquivo,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              height: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PaletaCores.corAzulCiano,
                                ),
                                onPressed: () {
                                  setState(() {
                                    boolExibirBotoes = false;
                                    exibicaoTela =
                                        Constantes.exibicaoTelaSelecaoLogo;
                                  });
                                },
                                child: Text(Textos.btnTrocarModelo,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
          ),
          onWillPop: () async {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaPesquisa);
            return false;
          },
        ));
  }
}
