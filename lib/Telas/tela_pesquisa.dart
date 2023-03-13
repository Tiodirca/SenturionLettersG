import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/Servicos/pesquisa_letra.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/widgets/tela_carregamento.dart';
import 'package:senturionlettersg/widgets/widget_listagem_links_selecionados.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key? key, required this.tipoPesquisa}) : super(key: key);

  final String tipoPesquisa;

  @override
  State<TelaPesquisa> createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  Estilo estilo = Estilo();
  List<Map<String, String>> resultadoLinks = [];
  bool boolExibirListagemLinks = false;
  bool boolExibirTelaCarregamento = false;
  bool boolExibirBotao = false;
  List<Map<dynamic, dynamic>> linksLetrasUnir = [];
  final chaveFormulario = GlobalKey<FormState>();
  TextEditingController controllerPesquisa = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // metodo para realizar a pesquisa dos links
  // que contem o conteudo digitado na barra de pesquisa pelo usuario
  realizarPesquisaLinksLetraTexto() async {
    await PesquisaLetra.pesquisarLinks(controllerPesquisa.text)
        .then((value) => setState(() {
              resultadoLinks = value;
              boolExibirTelaCarregamento = false;
              if (resultadoLinks.isNotEmpty) {
                boolExibirListagemLinks = true;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Textos.erroPesquisaInvalida)));
              }
            }));
  }



  Widget listagemLinksSelecaoLetraTexto(double larguraTela) => ListView.builder(
        itemCount: resultadoLinks.length,
        itemBuilder: (context, index) {
          // variaveis vao receber o valor do map
          String nomeMusica = resultadoLinks.elementAt(index).keys.toString();
          String linkMusica = resultadoLinks.elementAt(index).values.toString();
          // removendo caracteres que nao sao necessarios
          nomeMusica =
              nomeMusica.replaceAll('(AP7Wnd">', "").replaceAll(")", "");
          linkMusica = linkMusica.replaceAll("(", "").replaceAll(")", "");
          return ListTile(
            iconColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.link),
                SizedBox(
                  width: larguraTela * 0.7,
                  child: Text(
                      // removendo texto desnecessario para exibicao
                      nomeMusica,
                      textAlign: TextAlign.center),
                )
              ],
            ),

            onTap: () {
              Map dados = {};
              // caso a pesquisa for unica redirecionar o
              // usuario passando as seguintes informacoes
              if (widget.tipoPesquisa == Constantes.tipoPesquisaUnica) {
                dados[Constantes.parametrosTelaLinkLetra] = linkMusica;
                List<String> vazio = [];
                dados[Constantes.parametrosTelaLetra] = vazio;
                dados[Constantes.parametroTelaDividirLetraTexto] = "";
                dados[Constantes.parametrosTelaNomeLetra] = "";
                dados[Constantes.parametrosTelaModelo] = Constantes.logoGeral;
                Navigator.pushReplacementNamed(
                  context,
                  Constantes.rotaTelaListagemLetra,
                  arguments: dados,
                );
              } else {
                dados[Constantes.parametrosMapNomeLetra] = nomeMusica;
                dados[Constantes.parametrosMapLinkLetra] = linkMusica;
                if (linksLetrasUnir.length < 2) {
                  setState(() {
                    linksLetrasUnir.add(dados);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(Textos.erroNMaxLetrasUnir)));
                }
              }
            }, // Handle your onTap here.
          );
        },
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
              title: Text(Textos.telaPesquisa),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
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
                                        bottom: 20.0, top: 10.0),
                                    width: larguraTela,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      Textos.descricaoBarraPesquisaLetra,
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                Wrap(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        width: larguraTela * 0.7,
                                        child: Form(
                                          key: chaveFormulario,
                                          child: TextFormField(
                                            onFieldSubmitted: (value) {
                                              if (chaveFormulario.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  boolExibirListagemLinks =
                                                      false;
                                                  boolExibirTelaCarregamento =
                                                      true;
                                                });
                                                realizarPesquisaLinksLetraTexto();
                                              }
                                            },
                                            controller: controllerPesquisa,
                                            decoration: InputDecoration(
                                              labelStyle: const TextStyle(
                                                color: PaletaCores.corAzulMagenta
                                              ),
                                              labelText: Textos.labelBarraPesquisaLetra,
                                                hintText: Textos
                                                    .hintBarraPesquisaLetra),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return Textos.erroCampoVazio;
                                              }
                                              return null;
                                            },
                                          ),
                                        )),
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: FloatingActionButton(
                                          backgroundColor: Colors.white,
                                          onPressed: () async {
                                            if (chaveFormulario.currentState!
                                                .validate()) {
                                              setState(() {
                                                boolExibirListagemLinks = false;
                                                boolExibirTelaCarregamento =
                                                    true;
                                              });
                                              realizarPesquisaLinksLetraTexto();
                                            }
                                          },
                                          child: const Icon(
                                            Icons.search_rounded,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ))
                                  ],
                                ),
                                Visibility(
                                    visible: boolExibirListagemLinks,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 20.0,
                                        ),
                                        width: larguraTela,
                                        height: alturaTela * 0.7,
                                        child: Column(
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              Textos.descricaoListagemLinks,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            Visibility(
                                              visible: widget.tipoPesquisa ==
                                                      Constantes
                                                          .tipoPesquisaDupla
                                                  ? true
                                                  : false,
                                              child: SizedBox(
                                                width: larguraTela,
                                                height: alturaTela * 0.35,
                                                child:
                                                    WidgetListagemLinksSeleLetraTexto(
                                                        linksLetrasUnir:
                                                            linksLetrasUnir),
                                              ),
                                            ),
                                            SizedBox(
                                              width: larguraTela,
                                              height: alturaTela * 0.3,
                                              child:
                                                  listagemLinksSelecaoLetraTexto(
                                                      larguraTela),
                                            )
                                          ],
                                        ))),
                              ],
                            ));
                      }
                    },
                  )),
            ),
          ),
          onWillPop: () async {
            Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
            return false;
          },
        ));
  }
}
