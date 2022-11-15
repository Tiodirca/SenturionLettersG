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
  String exibicaoTela = Constantes.exibicaoTelaCarregar;
  List<String> primeiraLetraCompletaCortada = [];
  List<String> segundaLetraCompletaCortada = [];
  bool boolExibirTelaCarregamento = true;
  bool boolExibirLogo = false;
  final List<CheckBoxModel> itensCheckBox = [];
  String primeiraLetraNome = "";
  String segundaLetraNome = "";

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
    add(letraCortada);
  }

  add(List<dynamic> letraCortada) {
    for (int i = 0; i < letraCortada.length; i++) {
      itensCheckBox.add(CheckBoxModel(texto: letraCortada[i]));
    }
  }

  Widget listagemLetra(
          double larguraTela,
          double alturaTela,
          double tamanhoIcones,
          double tamanhoTexto,
          double tamanhoSlide,
          bool exibirLogo,
          List<String> letraCortada,
          String nomeLetra) =>
      Container(
          color: Colors.green,
          width: larguraTela,
          height: alturaTela * 0.7,
          child: Column(
            children: [
              Text(nomeLetra),
              SizedBox(
                width: larguraTela,
                height: alturaTela * 0.6,
                child: ListView.builder(
                  itemCount: letraCortada.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Container(
                            padding: const EdgeInsets.all(10),
                            width: larguraTela,
                            height: tamanhoSlide,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/imagens/fundo_letra.png'),
                                    fit: BoxFit.cover)),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                          nomeLetra,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                      letraCortada[index]
                                          .substring(5)
                                          .toString()
                                          .replaceAll(
                                              RegExp(
                                                r'</p>',
                                              ),
                                              '')
                                          .replaceAll(
                                              RegExp(
                                                Constantes
                                                    .stringPularLinhaSlide,
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
              )
            ],
          ));

  Widget checkBoxPersonalizado(
    CheckBoxModel checkBoxModel,
  ) =>
      CheckboxListTile(
        activeColor: PaletaCores.corCastanho,
        checkColor: PaletaCores.corVerdeCiano,
        secondary: SizedBox(
            width: 30,
            height: 30,
            child: FloatingActionButton(
              heroTag: "btnExcluirPessoa ${checkBoxModel.idItem}",
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.close, size: 20),
              onPressed: () {
                //exibirConfirmacaoExcluir(checkBoxModel.idItem);
              },
            )),
        title: Text(checkBoxModel.texto,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: Colors.black),
        onChanged: (value) {
          setState(() {
            // verificando se o balor
            checkBoxModel.checked = value!;
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
            return false;
          },
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
                  } else {
                    return SizedBox(
                      width: larguraTela,
                      height: alturaTela,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          listagemLetra(
                              larguraTela * 0.4,
                              alturaTela,
                              35,
                              20,
                              200,
                              boolExibirLogo,
                              primeiraLetraCompletaCortada,
                              primeiraLetraNome),
                          listagemLetra(
                              larguraTela * 0.4,
                              alturaTela,
                              35,
                              20,
                              200,
                              boolExibirLogo,
                              segundaLetraCompletaCortada,
                              segundaLetraNome),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
