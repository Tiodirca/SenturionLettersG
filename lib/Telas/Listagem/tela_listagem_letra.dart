import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/Servicos/PDF/GerarPDF.dart';
import 'package:senturionlettersg/Uteis/Servicos/gerar_arquivo.dart';
import 'package:senturionlettersg/Uteis/Servicos/pesquisa_letra.dart';
import 'package:senturionlettersg/Uteis/metodos_auxiliares.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';
import 'package:senturionlettersg/widgets/listagem_letra_widget.dart';
import 'package:senturionlettersg/widgets/tela_carregamento.dart';

class TelaLisagemLetra extends StatefulWidget {
  const TelaLisagemLetra(
      {Key? key,
      required this.linkLetra,
      required this.parametroDividirLetraTexto,
      required this.letraCompleta,
      required this.nomeLetra,
      required this.modelo})
      : super(key: key);

  final String linkLetra;
  final String parametroDividirLetraTexto;
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
    super.initState();
    // verificando se a lista nao e vazia
    // para determinar qual sera a acao executada
    if (widget.linkLetra.isNotEmpty) {
      realizarPesquisaLetraCompleta(); // chamando metodo
    } else if (widget.parametroDividirLetraTexto
        .contains(Constantes.parametroTelaDividirLetraTexto)) {
      letraCompletaCortada = widget.letraCompleta;
      nomeLetra = widget.nomeLetra;
      exibicaoTela = Constantes.exibicaoTelaSelecaoLogo;
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
    // definindo que a variavel vai receber o valor retornado pelo metodo
    letraCompletaCortada =
        MetodosAuxiliares.dividirLetraEstrofes(letraCompleta);

    // variavel vai receber o valor retornado pelo metodo
    nomeLetra = await PesquisaLetra.exibirTituloLetra();
  }

  mudarRadioButton(int value) {
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

  // metodo para passar os valores para o back end
  // para assim estar gerando o arquivo
  passarValoresGerarArquivo() async {
    setState(() {
      exibicaoTela = Constantes.exibicaoTelaCarregar;
      boolExibirBotoes = false;
    });
    GerarArquivo arquivo = GerarArquivo();
    String retornoMetodo = await arquivo.passarValoresGerarArquivo(
        letraCompletaCortada, tipoModelo, nomeLetra);
    if (retornoMetodo.contains(Constantes.retornoRequesicaoSucesso)) {
      setState(() {
        exibicaoTela = Constantes.exibicaoTelaListagemLetra;
        boolExibirBotoes = true;
      });
    } else {
      setState(() {
        exibicaoTela = Constantes.exibicaoTelaListagemLetra;
        boolExibirBotoes = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Textos.erroGerarArquivo + retornoMetodo.toString())));
      debugPrint(retornoMetodo.toString());
    }
  }

  Widget botao(String nomeBotao, Color corBotao) => SizedBox(
        width: 130,
        height: 65,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: corBotao, width: 2),
          ),
          onPressed: () {
            if (nomeBotao == Textos.btnTrocarModelo) {
              setState(() {
                boolExibirBotoes = false;
                exibicaoTela = Constantes.exibicaoTelaSelecaoLogo;
              });
            } else if (nomeBotao == Textos.btnGerarArquivo) {
              passarValoresGerarArquivo();
            } else if (nomeBotao == Textos.btnEditar) {
              Map dados = {};
              dados[Constantes.parametrosTelaLetra] = letraCompletaCortada;
              dados[Constantes.parametrosTelaNomeLetra] = nomeLetra;
              dados[Constantes.parametrosTelaModelo] = tipoModelo;
              dados[Constantes.parametrosTelaLinkLetra] = [];
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaEdicaoLetra,
                  arguments: dados);
            } else if (nomeBotao == Textos.btnBaixarPDF) {
              GerarPDF(
                      letraCompleta: letraCompletaCortada,
                      nomeLetra: nomeLetra,
                      exibirLogo: boolExibirLogo)
                  .gerarPDF();
            }
          },
          child: Text(nomeBotao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PaletaCores.corAzulMagenta,
                fontSize: 17,
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Theme(
      data: estilo.estiloGeral,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              if (widget.parametroDividirLetraTexto.isEmpty) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaPesquisa,
                    arguments: Constantes.tipoPesquisaUnica);
              } else {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaDividirLetraTexto);
              }
            },
          ),
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
              } else if (exibicaoTela == Constantes.exibicaoTelaSelecaoLogo) {
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
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: valorRadioButton == 0
                                        ? PaletaCores.corVerdeCiano
                                        : Colors.white,
                                  ),
                                  borderRadius: const BorderRadius.all(
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
                                        activeColor: PaletaCores.corCastanho,
                                        value: 0,
                                        groupValue: valorRadioButton,
                                        onChanged: (_) {
                                          mudarRadioButton(0);
                                        }),
                                    Text(
                                      Textos.radioButtonGeral,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: valorRadioButton == 1
                                        ? PaletaCores.corVerdeCiano
                                        : Colors.white,
                                  ),
                                  borderRadius: const BorderRadius.all(
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
                                        activeColor: PaletaCores.corCastanho,
                                        value: 1,
                                        groupValue: valorRadioButton,
                                        onChanged: (_) {
                                          mudarRadioButton(1);
                                        }),
                                    Text(
                                      Textos.radioButtonGeracaoFire,
                                      style: const TextStyle(
                                        color: Colors.black,
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
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                                width: 2, color: PaletaCores.corVerdeCiano),
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
                                color: PaletaCores.corAzulMagenta,
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
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            width: larguraTela,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${Textos.nomeLetra} : $nomeLetra",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${Textos.qtdSlides} ${letraCompletaCortada.length}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            )),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                              color: PaletaCores.corAzulMagenta,
                            ),
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(5.0),
                              width:
                                  MetodosAuxiliares.verificarTipoDispositivo()
                                      ? larguraTela * 0.8
                                      : larguraTela * 0.6,
                              height: alturaTela * 0.6,
                              child: ListView.builder(
                                itemCount: letraCompletaCortada.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      title: ConteudoLetraWidget(
                                    exibirLogo: boolExibirLogo,
                                    tituloLetra: nomeLetra,
                                    conteudoLetra:
                                        letraCompletaCortada.elementAt(index),
                                  ));
                                },
                              )),
                        ),
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
                        botao(Textos.btnEditar, PaletaCores.corCastanho),
                        botao(
                            Textos.btnGerarArquivo, PaletaCores.corVerdeCiano),
                        botao(Textos.btnBaixarPDF, PaletaCores.corVermelha),
                        botao(Textos.btnTrocarModelo, PaletaCores.corAzulCiano),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}
