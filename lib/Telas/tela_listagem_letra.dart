import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/Servicos/pesquisa_letra.dart';
import 'package:senturionlettersg/Uteis/Textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/widgets/tela_carregamento.dart';

class TelaLisagemLetra extends StatefulWidget {
  const TelaLisagemLetra({Key? key, required this.linkMusica})
      : super(key: key);

  final String linkMusica;

  @override
  State<TelaLisagemLetra> createState() => _TelaLisagemLetraState();
}

class _TelaLisagemLetraState extends State<TelaLisagemLetra> {
  Estilo estilo = Estilo();
  bool boolExibirTelaCarregamento = true;
  List<String> letraCompleta = [];
  List<String> letraCompletaCortada = [];
  List<String> letraCompletaExibicao = [];
  String tituloMusica = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.linkMusica);
    realizarPesquisaLetraCompleta();
  }

  realizarPesquisaLetraCompleta() async {
    await PesquisaLetra.pesquisarLetra(widget.linkMusica).then(
      (value) {
        letraCompleta = value;
        setState(() {
          //removendo primeiro index da lista pois o mesmo e vazio
          letraCompleta.removeAt(0);
          boolExibirTelaCarregamento = false;
        });
      },
    );

    for (var element in letraCompleta) {
      var corte = element.split("<br>");
      //print(corte);
      String versoConcatenado = "";
      for (int index = 0; index < corte.length; index++) {
        versoConcatenado =
            "$versoConcatenado ${Constantes.stringPularLinhaSlide} ${corte.elementAt(index)}";
        if (index == 3) {
          letraCompletaCortada.add(versoConcatenado);
          versoConcatenado = "";
        } else if (index == corte.length - 1) {
          letraCompletaCortada.add(versoConcatenado);
          versoConcatenado = "";
        }
      }
    }
    tituloMusica = await PesquisaLetra.exibirTituloLetra();
  }

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
                  if (boolExibirTelaCarregamento) {
                    return SizedBox(
                        width: larguraTela,
                        height: alturaTela,
                        child: const Center(
                          child: TelaCarregamento(),
                        ));
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
                              child: Text(
                                tituloMusica,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              width: larguraTela,
                              height: alturaTela * 0.6,
                              child: ListView.builder(
                                itemCount: letraCompletaCortada.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      title: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: larguraTela,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/imagens/fundo_letra.png'),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Visibility(
                                              visible: false,
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Image.asset(
                                                  'assets/imagens/logo_geracao_fire.png',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              tituloMusica,
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
                                            SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: Image.asset(
                                                'assets/imagens/logo_adtl.png',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                            letraCompletaCortada[index]
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
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 10.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 10.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 10.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 10.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ));
                                },
                              ),
                            )
                          ],
                        ));
                  }
                },
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.green,
              width: larguraTela,
              height: alturaTela * 0.1,
            ),
          ),
          onWillPop: () async {
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaPesquisa);
            return false;
          },
        ));
  }
}
