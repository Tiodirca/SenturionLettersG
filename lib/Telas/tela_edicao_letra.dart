import 'dart:io';

import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';

class TelaEdicaoLetra extends StatefulWidget {
  const TelaEdicaoLetra(
      {Key? key,
      required this.letraCompleta,
      required this.nomeLetra,
      required this.modelo})
      : super(key: key);

  final List<String> letraCompleta;
  final String nomeLetra;
  final String modelo;

  @override
  State<TelaEdicaoLetra> createState() => _TelaEdicaoLetraState();
}

class _TelaEdicaoLetraState extends State<TelaEdicaoLetra> {
  Estilo estilo = Estilo();
  bool boolExibirTelaCarregamento = true;
  bool boolExibirBotoes = false;
  bool boolExibirLogo = false;
  late String tipoLogo = widget.modelo;
  int valorRadioButton = 0;
  String exibicaoTela = Constantes.exibicaoTelaListagemLetra;
  List<String> letraCompletaEditada = [];
  String nomeLetra = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nomeLetra = widget.nomeLetra;
    if (widget.modelo == Constantes.logoGeral) {
      boolExibirLogo = false;
    } else {
      boolExibirLogo = true;
    }
    boolExibirBotoes = true;
    letraCompletaEditada = widget.letraCompleta;
  }

  void mudarRadioButton(int value) {
    //metodo para mudar o estado do radio button
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            tipoLogo = Constantes.logoGeral;
            boolExibirLogo = false;
          });
          break;
        case 1:
          setState(() {
            tipoLogo = Constantes.logoGeracaoFire;
            boolExibirLogo = true;
          });
          break;
      }
    });
  }

  Widget listagemLetra(double larguraTela, double alturaTela,
          double tamanhoIcones, double tamanhoTexto, double tamanhoSlide) =>
      Container(
        padding: const EdgeInsets.only(bottom: 10),
        width: larguraTela,
        height: alturaTela * 0.6,
        child: ListView.builder(
          itemCount: letraCompletaEditada.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Container(
              width: larguraTela,
              height: tamanhoSlide,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/imagens/fundo_letra.png'),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  SizedBox(
                    height: tamanhoSlide == 300 ? 60 : 40,
                    child: Row(
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
                  ),
                  SizedBox(
                    height: tamanhoSlide == 300 ? 160 : 120,
                    child: TextFormField(
                        textAlign: TextAlign.center,
                        initialValue: letraCompletaEditada[index]
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
                        onChanged: (value) {
                          print(value);
                          String valor =
                              " ${Constantes.stringPularLinhaSlide} $value";
                          print(valor);
                          letraCompletaEditada[index] = valor;
                        },
                        maxLines: 10,
                        minLines: 4,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          shadows: <Shadow>[
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
                        ),
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        )),
                  ),
                  SizedBox(
                    height: tamanhoSlide == 300 ? 60 : 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: tamanhoSlide == 300 ? 40 : 35,
                          height: tamanhoSlide == 300 ? 40 : 35,
                          child: FloatingActionButton(
                              heroTag: "btnAdd$index",
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: tamanhoSlide == 300 ? 30 : 30,
                              ),
                              onPressed: () {
                                letraCompletaEditada.insert(index + 1, "");
                                Map dados = {};
                                dados[Constantes.parametrosTelaLetra] =
                                    letraCompletaEditada;
                                dados[Constantes.paramatrosTelaNomeLetra] =
                                    nomeLetra;
                                dados[Constantes.parametrosTelaModelo] =
                                    tipoLogo;
                                Navigator.pushReplacementNamed(
                                    context, Constantes.rotaTelaEdicaoLetra,
                                    arguments: dados);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(Textos.sucessoAddSlide)));
                              }),
                        ),
                        SizedBox(
                          width: tamanhoSlide == 300 ? 40 : 35,
                          height: tamanhoSlide == 300 ? 40 : 35,
                          child: FloatingActionButton(
                            heroTag: "btnClose$index",
                            backgroundColor: Colors.white,
                            onPressed: () {
                              if (letraCompletaEditada.length == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(Textos.erroUmSlide)));
                              } else {
                                letraCompletaEditada.removeAt(index);
                                Map dados = {};
                                dados[Constantes.parametrosTelaLetra] =
                                    letraCompletaEditada;
                                dados[Constantes.paramatrosTelaNomeLetra] =
                                    nomeLetra;
                                dados[Constantes.parametrosTelaModelo] =
                                    tipoLogo;
                                Navigator.pushReplacementNamed(
                                    context, Constantes.rotaTelaEdicaoLetra,
                                    arguments: dados);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(Textos.sucessoRemoSlide)));
                              }
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: tamanhoSlide == 300 ? 30 : 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
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
              title: Text(Textos.telaEdicaoLetra),
            ),
            body: Container(
              margin: const EdgeInsets.only(right: 10.0, left: 10.0),
              width: larguraTela,
              height: alturaTela,
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (exibicaoTela == Constantes.exibicaoTelaSelecaoLogo) {
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
                                Textos.descricaoTelaEdicaoLetra,
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
                                      "Quantidade de Slides : ${letraCompletaEditada.length}",
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
                                      alturaTela, 50, 30, 300);
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
                                  backgroundColor: PaletaCores.corVerdeCiano,
                                ),
                                onPressed: () {
                                  var slideVazio = [...letraCompletaEditada]
                                      .every((el) =>
                                          el.toString().isNotEmpty &&
                                          el.toString() ==
                                              Constantes.stringPularLinhaSlide);
                                  print("EDICAO$letraCompletaEditada");
                                  if (slideVazio) {
                                    Map dados = {};
                                    dados[Constantes.parametrosTelaLinkLetra] =
                                        "";
                                    dados[Constantes.parametrosTelaLetra] =
                                        letraCompletaEditada;
                                    dados[Constantes.paramatrosTelaNomeLetra] =
                                        nomeLetra;
                                    dados[Constantes.parametrosTelaModelo] =
                                        tipoLogo;
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Constantes.rotaTelaListagemLetra,
                                      arguments: dados,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(Textos.erroSlideVazio)));
                                  }
                                },
                                child: Text(Textos.btnSalvar,
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
            Map dados = {};
            dados[Constantes.parametrosTelaLinkLetra] = "";
            dados[Constantes.parametrosTelaLetra] = widget.letraCompleta;
            dados[Constantes.paramatrosTelaNomeLetra] = nomeLetra;
            dados[Constantes.parametrosTelaModelo] = widget.modelo;
            Navigator.pushReplacementNamed(
              context,
              Constantes.rotaTelaListagemLetra,
              arguments: dados,
            );
            return false;
          },
        ));
  }
}
