import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/Servicos/gerar_arquivo.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/Uteis/metodos_auxiliares.dart';
import 'package:senturionlettersg/widgets/listagem_letra_widget.dart';

import '../Modelo/check_box_model.dart';
import '../Uteis/Servicos/pesquisa_letra.dart';
import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';
import '../widgets/tela_carregamento.dart';

class TelaListagemLetraUnir extends StatefulWidget {
  const TelaListagemLetraUnir(
      {Key? key,
      required this.linksLetraLetrasUnir,
      required this.infoComplementares})
      : super(key: key);

  final List<String> linksLetraLetrasUnir;
  final List<dynamic> infoComplementares;

  @override
  State<TelaListagemLetraUnir> createState() => _TelaListagemLetraUnirState();
}

class _TelaListagemLetraUnirState extends State<TelaListagemLetraUnir> {
  Estilo estilo = Estilo();
  int ordemEstrofes = 0;
  int valorRadioButton = 0;
  String exibicaoTela = Constantes.exibicaoTelaCarregar;
  List<String> primeiraLetraCompleta = [];
  List<String> segundaLetraCompleta = [];
  bool boolExibirTelaCarregamento = true;
  late String tipoModelo = Constantes.logoGeral;
  bool boolExibirLogo = false;
  final List<CheckBoxModel> itensCBPrimeiraLetra = [];
  final List<CheckBoxModel> itensCBSegundaLetra = [];
  String primeiraLetraNome = "";
  String segundaLetraNome = "";
  List<String> letraFinal = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iniciarPesquisa();
  }

  iniciarPesquisa() async {
    String primeiroLink = "";
    String segundoLink = "";
    // caso a variavel seja vazia quer dizer
    // que e a tela esta vindo da tela de pesquisa
    // caso contrario esta vindo da tela de edicao
    if (widget.infoComplementares.isEmpty) {
      // index 0 e 1 corresponde aos links passados para a lista
      // na tela de pesquisa
      primeiroLink = widget.linksLetraLetrasUnir.elementAt(0);
      segundoLink = widget.linksLetraLetrasUnir.elementAt(1);
    } else {
      // index 0 e 1 corresponde aos links passados a lista
      // na tela de edicao
      primeiroLink = widget.infoComplementares.elementAt(0);
      segundoLink = widget.infoComplementares.elementAt(1);
      letraFinal = widget.linksLetraLetrasUnir;
      // verificando se qual o tipo de logo foi
      // passado no index 2 da lista para exibir logo
      if (widget.infoComplementares
          .elementAt(2)
          .toString()
          .contains(Constantes.logoGeral)) {
        boolExibirLogo = false;
      } else {
        boolExibirLogo = true;
      }
    }
    primeiraLetraCompleta = await realizarPesquisaLetraCompleta(primeiroLink);
    //verificando se a pesquisa retornou algum erro ou nao
    if (primeiraLetraCompleta.first.contains(Constantes.msgErroPesquisaLetra)) {
      exibirMensagemErro();
    } else {
      primeiraLetraNome = await PesquisaLetra.exibirTituloLetra();
      adicionarLetraCheckBox(
          itensCBPrimeiraLetra, primeiraLetraCompleta, primeiraLetraNome);
    }

    segundaLetraCompleta = await realizarPesquisaLetraCompleta(segundoLink);
    //verificando se a pesquisa retornou algum erro ou nao
    if (segundaLetraCompleta.first.contains(Constantes.msgErroPesquisaLetra)) {
      exibirMensagemErro();
    } else {
      segundaLetraNome = await PesquisaLetra.exibirTituloLetra();
      adicionarLetraCheckBox(
          itensCBSegundaLetra, segundaLetraCompleta, segundaLetraNome);
    }

    setState(() {
      exibicaoTela = "";
      boolExibirTelaCarregamento = false;
      // verificando se a variavel e vazia para alterar valor da variavel
      // exibindo tela correspondente
      if (widget.infoComplementares.isEmpty) {
        exibicaoTela = Constantes.exibicaoTelaSelecaoLogo;
      }
    });
  }

  // metodo responsavel por exibir mensagem de erro caso a pesquisa
  // de erro
  exibirMensagemErro() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(Textos.erroPesquisaLetraUnir)));
  }

  // metodo responsavel por chamar metodo para
  // realizar a pesquisa da letra completa
  realizarPesquisaLetraCompleta(String linkLetra) async {
    List<String> letraCompleta = [];
    await PesquisaLetra.pesquisarLetra(linkLetra).then(
      (value) {
        letraCompleta = value;
        setState(() {
          //removendo primeiro index da lista pois o mesmo e vazio
          if (letraCompleta.isNotEmpty &&
              !(letraCompleta.first
                  .contains(Constantes.msgErroPesquisaLetra))) {
            letraCompleta.removeAt(0);
          }
        });
      },
    );
    return MetodosAuxiliares.dividirLetraEstrofes(letraCompleta);
  }

  // metodo para adicionar a letra devidamente cortada num check box para selecao
  adicionarLetraCheckBox(List<CheckBoxModel> itensCheckBox,
      List<dynamic> letraCortada, String tituloLetra) {
    for (int i = 0; i < letraCortada.length; i++) {
      itensCheckBox
          .add(CheckBoxModel(texto: letraCortada[i], tituloLetra: tituloLetra));
    }
  }

  // metodo para passar os valores para o back end
  // para assim estar gerando o arquivo
  passarValoresGerarArquivo() async {
    setState(() {
      exibicaoTela = Constantes.exibicaoTelaCarregar;
    });
    GerarArquivo arquivo = GerarArquivo();
    String retornoMetodo = await arquivo.passarValoresGerarArquivo(
        letraFinal, tipoModelo, "nomeLetra");
    if (retornoMetodo.contains(Constantes.retornoRequesicaoSucesso)) {
      setState(() {
        exibicaoTela = Constantes.exibicaoTelaListagemLetra;
      });
    } else {
      setState(() {
        exibicaoTela = Constantes.exibicaoTelaListagemLetra;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Textos.erroGerarArquivo + retornoMetodo.toString())));
      debugPrint(retornoMetodo.toString());
    }
  }

  // metodo para exibir corretamente a numeracao indicando a ordem que os itens
  // foram selecionados
  exibirOrdemSlides(CheckBoxModel checkBoxModel) {
    String valor = "";
    for (int i = 0; i < letraFinal.length; i++) {
      if (letraFinal[i] == checkBoxModel.texto) {
        valor = i.toString();
        checkBoxModel.checked = true;
      }
    }
    return valor.toString();
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

  Widget checkBoxPersonalizado(
    bool exibirLogo,
    CheckBoxModel checkBoxModel,
  ) =>
      CheckboxListTile(
        activeColor: PaletaCores.corAzulMagenta,
        checkColor: Colors.white,
        secondary: Text(exibirOrdemSlides(checkBoxModel)),
        title: ConteudoLetraWidget(
            exibirLogo: exibirLogo,
            conteudoLetra: checkBoxModel.texto,
            tituloLetra: checkBoxModel.tituloLetra),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: Colors.black),
        onChanged: (value) {
          setState(() {
            checkBoxModel.checked = value!;
            //verificando se o valor e verdadeiro
            if (checkBoxModel.checked == true) {
              ordemEstrofes++;
              letraFinal.add(checkBoxModel.texto);
            } else {
              ordemEstrofes--;
              letraFinal.remove(checkBoxModel.texto);
            }
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacementNamed(context, Constantes.rotaTelaPesquisa,
                arguments: false);
            //Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(Textos.telaVisualizacaoLetraUnir),
            ),
            body: SizedBox(
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
                                            onChanged: (_) async {
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
                                  //boolExibirBotoes = true;
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
                    return SizedBox(
                        width: larguraTela,
                        height: alturaTela * 0.7,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: alturaTela,
                                  width: larguraTela,
                                  child: Text(
                                    Textos.descricaoTelaVisualizacaoLetraUnir,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                )),
                            Expanded(
                                flex: 10,
                                child: SizedBox(
                                    width: larguraTela,
                                    height: alturaTela,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(primeiraLetraNome,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: const BorderSide(
                                                      color: PaletaCores
                                                          .corAzulMagenta,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    width: MetodosAuxiliares
                                                            .verificarTipoDispositivo()
                                                        ? larguraTela * 0.9
                                                        : 500,
                                                    height: alturaTela * 0.6,
                                                    child: ListView(
                                                      children: [
                                                        ...itensCBPrimeiraLetra
                                                            .map((e) =>
                                                                checkBoxPersonalizado(
                                                                  boolExibirLogo,
                                                                  e,
                                                                ))
                                                            .toList()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${Textos.qtdSlides} ${itensCBPrimeiraLetra.length}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(segundaLetraNome,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: const BorderSide(
                                                      color: PaletaCores
                                                          .corAzulMagenta,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    width: MetodosAuxiliares
                                                            .verificarTipoDispositivo()
                                                        ? larguraTela * 0.9
                                                        : 500,
                                                    height: alturaTela * 0.6,
                                                    child: ListView(
                                                      children: [
                                                        ...itensCBSegundaLetra
                                                            .map((e) =>
                                                                checkBoxPersonalizado(
                                                                  boolExibirLogo,
                                                                  e,
                                                                ))
                                                            .toList()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${Textos.qtdSlides} ${itensCBSegundaLetra.length}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(Textos.txtLetraFinalUnir,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: const BorderSide(
                                                      color: PaletaCores
                                                          .corAzulMagenta,
                                                    ),
                                                  ),
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      width: MetodosAuxiliares
                                                              .verificarTipoDispositivo()
                                                          ? larguraTela * 0.9
                                                          : 500,
                                                      height: alturaTela * 0.6,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            letraFinal.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                              title:
                                                                  ConteudoLetraWidget(
                                                            exibirLogo:
                                                                boolExibirLogo,
                                                            tituloLetra: "fdsf",
                                                            conteudoLetra:
                                                                letraFinal
                                                                    .elementAt(
                                                                        index),
                                                          ));
                                                        },
                                                      )),
                                                ),
                                                Text(
                                                    "${Textos.qtdSlides} ${letraFinal.length}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )))),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 70,
                                width: larguraTela,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      height: 65,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              PaletaCores.corCastanho,
                                        ),
                                        onPressed: () {
                                          if (letraFinal.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(Textos
                                                        .erroLetraFinalVazia)));
                                          } else {
                                            Map dados = {};
                                            List<dynamic>
                                                infoComplementaresBtn = [];
                                            //adicionando informacoes
                                            infoComplementaresBtn
                                                .add("nomeLetra"); // index 0
                                            infoComplementaresBtn
                                                .add(tipoModelo); // index 1
                                            infoComplementaresBtn.add(Constantes
                                                .listagemLetraUnir); // index 2
                                            // verificando se a variavel possui
                                            // algum valor dentro para definir quais
                                            // informacoes serao adicionadas
                                            if (widget
                                                .infoComplementares.isEmpty) {
                                              infoComplementaresBtn.add(widget
                                                  .linksLetraLetrasUnir
                                                  .elementAt(0)); // index 3
                                              infoComplementaresBtn.add(widget
                                                  .linksLetraLetrasUnir
                                                  .elementAt(1)); // index 4
                                            } else {
                                              infoComplementaresBtn.add(widget
                                                  .infoComplementares
                                                  .elementAt(0)); // index 3
                                              infoComplementaresBtn.add(widget
                                                  .infoComplementares
                                                  .elementAt(1)); // index 4
                                            }
                                            dados[Constantes
                                                    .parametrosInfoComplementares] =
                                                infoComplementaresBtn;
                                            dados[Constantes
                                                    .parametrosTelaLetra] =
                                                letraFinal;
                                            Navigator.pushReplacementNamed(
                                                context,
                                                Constantes.rotaTelaEdicaoLetra,
                                                arguments: dados);
                                          }
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
                                          backgroundColor:
                                              PaletaCores.corVerdeCiano,
                                        ),
                                        onPressed: () {
                                          if (letraFinal.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(Textos
                                                        .erroLetraFinalVazia)));
                                          } else {
                                            passarValoresGerarArquivo();
                                          }
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
                                          backgroundColor:
                                              PaletaCores.corAzulCiano,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            exibicaoTela = Constantes
                                                .exibicaoTelaSelecaoLogo;
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
                            )
                          ],
                        ));
                  }
                },
              ),
            ),
          ),
        ));
  }
}
