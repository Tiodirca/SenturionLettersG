import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';

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
  bool boolExibirLogo = false;
  final List<CheckBoxModel> itensCheckBoxPrimeiraLetra = [];
  final List<CheckBoxModel> itensCheckBoxSegundaLetra = [];
  String primeiraLetraNome = "";
  String segundaLetraNome = "";
  List<String> letraResultante = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    realizarPesquisaLetraCompleta(
        primeiraLetraCompletaCortada,
        primeiraLetraNome,
        widget.linksLetrasUnir.elementAt(0)[Constantes.paraLinkLetra]);
    realizarPesquisaLetraCompleta(segundaLetraCompletaCortada, segundaLetraNome,
        widget.linksLetrasUnir.elementAt(1)[Constantes.paraLinkLetra]);

    primeiraLetraNome = widget.linksLetrasUnir
        .elementAt(0)[Constantes.paraNomeLetra]
        .toString()
        .replaceAll("- LETRAS.MUS.BR", "");
    segundaLetraNome = widget.linksLetrasUnir
        .elementAt(1)[Constantes.paraNomeLetra]
        .toString()
        .replaceAll("- LETRAS.MUS.BR", "");
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
          exibicaoTela = Constantes.exibicaoTelaSelecaoLogo;
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
    double larguraTela,
    double alturaTela,
    double tamanhoIcones,
    double tamanhoTexto,
    double tamanhoSlide,
    bool exibirLogo,
    CheckBoxModel checkBoxModel,
  ) =>
      CheckboxListTile(
        activeColor: PaletaCores.corCastanho,
        checkColor: PaletaCores.corVerdeCiano,
        secondary: Text(exibirOrdem(checkBoxModel)),
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
                            visible: exibirLogo,
                            child: Image.asset(
                              'assets/imagens/logo_geracao_fire.png',
                            ),
                          )),
                      SizedBox(
                        width: larguraTela * 0.5,
                        child: Text(
                          checkBoxModel.tituloLetra,
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
                      checkBoxModel.texto
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
                      )),
                ],
              ),
            )),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: Colors.black),
        onChanged: (value) {
          setState(() {
            // verificando se o balor
            checkBoxModel.checked = value!;
            if (checkBoxModel.checked == true) {
              ordemEstrofes++;
              letraResultante.add(checkBoxModel.texto);
            } else {
              ordemEstrofes--;
              letraResultante.remove(checkBoxModel.texto);
            }
          });
        },
      );

  Widget listagemLetra(
          double larguraTela,
          double alturaTela,
          double tamanhoIcones,
          double tamanhoTexto,
          double tamanhoSlide,
          List<String> letra) =>
      SizedBox(
        width: larguraTela,
        height: alturaTela * 0.6,
        child: ListView.builder(
          itemCount: letra.length,
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
                                child: const Text(
                                  "nomeLetra",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                              letra[index]
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

  exibirOrdem(CheckBoxModel checkBoxModel) {
    String valor = "";
    for (int i = 0; i < letraResultante.length; i++) {
      if (letraResultante[i] == checkBoxModel.texto) {
        valor = (i - 1).toString();
      }
    }
    return valor.toString();
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
                  } else {
                    return SizedBox(
                        width: larguraTela,
                        height: alturaTela,
                        child: Column(
                          children: [
                            Text(Textos.descricaoTelaVisualizacaoLetraUnir),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              height: alturaTela * 0.8,
                              color: Colors.green,
                              width: larguraTela,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(Textos.descricaoLetrasPJuntar,
                                          style: const TextStyle(fontSize: 18)),
                                      SizedBox(
                                        height: alturaTela * 0.7,
                                        width: larguraTela * 0.6,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: larguraTela * 0.3,
                                              height: alturaTela,
                                              child: ListView(
                                                children: [
                                                  ...itensCheckBoxPrimeiraLetra
                                                      .map((e) =>
                                                          checkBoxPersonalizado(
                                                            larguraTela * 0.3,
                                                            alturaTela,
                                                            35,
                                                            20,
                                                            200,
                                                            boolExibirLogo,
                                                            e,
                                                          ))
                                                      .toList()
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: larguraTela * 0.3,
                                              height: alturaTela,
                                              child: ListView(
                                                children: [
                                                  ...itensCheckBoxSegundaLetra
                                                      .map((e) =>
                                                          checkBoxPersonalizado(
                                                            larguraTela * 0.3,
                                                            alturaTela,
                                                            35,
                                                            20,
                                                            200,
                                                            boolExibirLogo,
                                                            e,
                                                          ))
                                                      .toList()
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(Textos.descricaoLetraResultante,
                                          style: const TextStyle(fontSize: 18)),
                                      SizedBox(
                                          width: larguraTela * 0.3,
                                          height: alturaTela * 0.7,
                                          child: listagemLetra(
                                              larguraTela * 0.3,
                                              alturaTela,
                                              35,
                                              20,
                                              200,
                                              letraResultante)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
                  }
                },
              ),
            ),
            bottomSheet: Container(
              height: 70,
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
                        if (letraResultante.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(Textos.erroLetraResultanteVazia)));
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
