import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/textos.dart';

class WidgetListagemLinksSeleLetraTexto extends StatefulWidget {
  WidgetListagemLinksSeleLetraTexto({Key? key, required this.linksLetrasUnir})
      : super(
          key: key,
        );

  List<Map<dynamic, dynamic>> linksLetrasUnir;

  @override
  State<WidgetListagemLinksSeleLetraTexto> createState() => _WidgetListagemLinksSeleLetraTextoState();
}

class _WidgetListagemLinksSeleLetraTextoState extends State<WidgetListagemLinksSeleLetraTexto> {
  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          Textos.descricaoListagemLinksLetraUnir,
          style: const TextStyle(fontSize: 20),
        ),
        SizedBox(
            width: larguraTela,
            height: alturaTela * 0.3,
            child: Column(
              children: [
                Container(
                  width: larguraTela,
                  height: alturaTela * 0.15,
                  child: ListView.builder(
                    itemCount: widget.linksLetrasUnir.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: larguraTela * 0.7,
                            child: Text(widget.linksLetrasUnir
                                .elementAt(
                                    index)[Constantes.parametrosMapNomeLetra]
                                .toString()),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            width: 30,
                            height: 30,
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              heroTag: "btnExcluir$index",
                              child: const Icon(
                                color: Colors.black,
                                Icons.close,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.linksLetrasUnir.removeAt(index);
                                });
                              },
                            ),
                          )
                        ],
                      ));
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.linksLetrasUnir.isEmpty ||
                          widget.linksLetrasUnir.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(Textos.erroSelecaoLetraUnir)));
                      } else {
                        List<dynamic> links = [];
                        Map dados = {};
                        // adicionando os links a uma lista
                        links.add(widget.linksLetrasUnir
                            .elementAt(0)[Constantes.parametrosMapLinkLetra]);
                        links.add(widget.linksLetrasUnir
                            .elementAt(1)[Constantes.parametrosMapLinkLetra]);

                        dados[Constantes.parametrosTelaLinkLetra] = links;
                        dados[Constantes.parametrosTelaLetraEditada] = [];
                        dados[Constantes.parametrosTelaNomeLetra] = "";
                        dados[Constantes.parametrosTelaModelo] = "";
                        Navigator.pushReplacementNamed(
                          context,
                          Constantes.rotaTelaListagemLetraUnir,
                          arguments: dados,
                        );
                      }
                    },
                    child: Text(Textos.btnUsar,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
