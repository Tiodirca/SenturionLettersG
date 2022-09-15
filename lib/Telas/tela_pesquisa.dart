import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/Servicos/pesquisa_letra.dart';
import 'package:senturionlettersg/Uteis/Textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/widgets/tela_carregamento.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key? key}) : super(key: key);

  @override
  State<TelaPesquisa> createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  Estilo estilo = Estilo();
  List<Map<String, String>> resultadoLinks = [];
  bool boolExibirListagemLinks = false;
  bool boolExibirTelaCarregamento = false;

  final chaveFormulario = GlobalKey<FormState>();
  TextEditingController controllerPesquisa = TextEditingController();

  // metodo para realizar a pesquisa dos links
  // que contem o conteudo digitado na barra de pesquisa pelo usuario
  realizarPesquisaLinks() async {
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
                                            controller: controllerPesquisa,
                                            decoration: InputDecoration(
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
                                              realizarPesquisaLinks();
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
                                        height: alturaTela * 0.6,
                                        child: Column(
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              Textos.descricaoListagemLinks,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                              ),
                                              width: larguraTela,
                                              height: alturaTela * 0.5,
                                              child: ListView.builder(
                                                itemCount:
                                                    resultadoLinks.length,
                                                itemBuilder: (context, index) {
                                                  // variaveis vao receber o valor do map
                                                  String nomeMusica =
                                                      resultadoLinks
                                                          .elementAt(index)
                                                          .keys
                                                          .toString();
                                                  String linkMusica =
                                                      resultadoLinks
                                                          .elementAt(index)
                                                          .values
                                                          .toString();
                                                  return ListTile(
                                                    iconColor: Colors.black,
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        const Icon(Icons.link),
                                                        SizedBox(
                                                          width:
                                                              larguraTela * 0.7,
                                                          child: Text(
                                                              // removendo texto desnecessario para exibicao
                                                              nomeMusica
                                                                  .replaceAll(
                                                                      '(AP7Wnd">',
                                                                      "")
                                                                  .replaceAll(
                                                                      ")", ""),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        )
                                                      ],
                                                    ),

                                                    onTap: () {
                                                      // passando como argumento texto
                                                      // e removendo texto desnecessario link da musica
                                                      // funcionar
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        Constantes
                                                            .rotaTelaListagemLetra,
                                                        arguments: linkMusica
                                                            .replaceAll("(", "")
                                                            .replaceAll(
                                                                ")", ""),
                                                      );
                                                    }, // Handle your onTap here.
                                                  );
                                                },
                                              ),
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
