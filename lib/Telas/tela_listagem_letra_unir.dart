import 'package:flutter/material.dart';
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
  const TelaListagemLetraUnir({Key? key, required this.linksLetrasUnir})
      : super(key: key);

  final List<Map<dynamic, dynamic>> linksLetrasUnir;

  @override
  State<TelaListagemLetraUnir> createState() => _TelaListagemLetraUnirState();
}

class _TelaListagemLetraUnirState extends State<TelaListagemLetraUnir> {
  Estilo estilo = Estilo();
  int ordemEstrofes = 0;
  String exibicaoTela = Constantes.exibicaoTelaCarregar;
  List<String> primeiraLetraCompletaCortada = [];
  List<String> segundaLetraCompletaCortada = [];
  bool boolExibirTelaCarregamento = true;
  late String tipoModelo = "";
  bool boolExibirLogo = false;
  final List<CheckBoxModel> itensCheckBoxPrimeiraLetra = [];
  final List<CheckBoxModel> itensCheckBoxSegundaLetra = [];
  String primeiraLetraNome = "";
  String segundaLetraNome = "";
  int valorRadioButton = 0;
  List<String> letraFinal = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String priLetra = "https://www.letras.mus.br/mara-lima/950724";
    String segLetra = "https://www.letras.mus.br/ministerio-avivah/maranata";
    //widget.linksLetrasUnir.elementAt(0)[Constantes.paraLinkLetra]
    realizarPesquisaLetraCompleta(
        primeiraLetraCompletaCortada, primeiraLetraNome, priLetra);
    realizarPesquisaLetraCompleta(
        segundaLetraCompletaCortada, segundaLetraNome, segLetra);

    // primeiraLetraNome = widget.linksLetrasUnir
    //     .elementAt(0)[Constantes.paraNomeLetra]
    //     .toString()
    //     .replaceAll("- LETRAS.MUS.BR", "");
    // segundaLetraNome = widget.linksLetrasUnir
    //     .elementAt(1)[Constantes.paraNomeLetra]
    //     .toString()
    //     .replaceAll("- LETRAS.MUS.BR", "");
    primeiraLetraNome = "Divino Companheiro - Mara Lima";
    segundaLetraNome = "Maranata - Ministério Avivah ";
  }

  // metodo responsavel por chamar metodo para realizar a pesquisa da letra completa
  realizarPesquisaLetraCompleta(
      List<dynamic> letraCortada, String nomeLetra, String linkLetra) async {
    List<String> letraCompleta = [];
    await PesquisaLetra.pesquisarLetra(linkLetra).then(
      (value) {
        letraCompleta = value;
        setState(() {
          //removendo primeiro index da lista pois o mesmo e vazio
          letraCompleta.removeAt(0);
          exibicaoTela = "fsfdsf";
          //exibicaoTela = Constantes.exibicaoTelaSelecaoLogo;
          boolExibirTelaCarregamento = false;
        });
      },
    );

    dividirLetraEstrofes(letraCompleta, letraCortada);
    adicionarLetraCheckBox(itensCheckBoxPrimeiraLetra,
        primeiraLetraCompletaCortada, primeiraLetraNome);
    adicionarLetraCheckBox(itensCheckBoxSegundaLetra,
        segundaLetraCompletaCortada, segundaLetraNome);
  }

  dividirLetraEstrofes(List<String> letraCompleta, List<dynamic> letraCortada) {
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
          letraCortada.add(versoConcatenado);
          versoConcatenado = "";
        } else if (index == corte.length - 1) {
          letraCortada.add(versoConcatenado);
          versoConcatenado = "";
        }
      }
    }
  }

  adicionarLetraCheckBox(List<CheckBoxModel> itensCheckBox,
      List<dynamic> letraCortada, String tituloLetra) {
    for (int i = 0; i < letraCortada.length; i++) {
      itensCheckBox
          .add(CheckBoxModel(texto: letraCortada[i], tituloLetra: tituloLetra));
    }
  }

  Widget checkBoxPersonalizado(
    bool exibirLogo,
    CheckBoxModel checkBoxModel,
  ) =>
      CheckboxListTile(
        activeColor: PaletaCores.corCastanho,
        checkColor: PaletaCores.corVerdeCiano,
        secondary: Text(exibirOrdemSlides(checkBoxModel)),
        title: ConteudoLetraWidget(
            exibirLogo: exibirLogo,
            conteudoLetra: checkBoxModel.texto,
            tituloLetra: checkBoxModel.tituloLetra),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: Colors.black),
        onChanged: (value) {
          setState(() {
            // verificando se o balor
            checkBoxModel.checked = value!;
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

  exibirOrdemSlides(CheckBoxModel checkBoxModel) {
    String valor = "";
    for (int i = 0; i < letraFinal.length; i++) {
      if (letraFinal[i] == checkBoxModel.texto) {
        valor = i.toString();
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
                  }
                  else if (exibicaoTela ==
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
                  }
                   else {
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
                                                        ...itensCheckBoxPrimeiraLetra
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
                                                    "${Textos.qtdSlides} ${itensCheckBoxPrimeiraLetra.length}",
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
                                                        ...itensCheckBoxSegundaLetra
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
                                                    "${Textos.qtdSlides} ${itensCheckBoxSegundaLetra.length}",
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
                                color: Colors.amberAccent,
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
                                              PaletaCores.corVerdeCiano,
                                        ),
                                        onPressed: () {
                                          if (letraFinal.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(Textos
                                                        .erroLetraResultanteVazia)));
                                          } else {
                                            setState(() {});
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
