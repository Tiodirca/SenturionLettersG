import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';

class TelaInicial extends StatelessWidget {
  TelaInicial({Key? key}) : super(key: key);

  Estilo estilo = Estilo();

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Theme(
        data: estilo.estiloGeral,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Textos.nomeApp),
            leading: const Icon(Icons.add, color: Colors.blueAccent),
          ),
          body: SizedBox(
            width: larguraTela,
            height: alturaTela,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        bottom: 20.0, top: 10.0),
                    width: larguraTela,
                    child: Text(
                      textAlign: TextAlign.center,
                      Textos.descricaoTelaInicial,
                      style: const TextStyle(fontSize: 20),
                    )),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 200,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaPesquisa,
                            arguments: true);
                      },
                      child: Text(Textos.btnTelaPesquisaInternet,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 200,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaPesquisa,
                            arguments: false);
                      },
                      child: Text(Textos.btnUnirLetras,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 200,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        // List<Map<dynamic,dynamic>> sa = [];
                        // Map dados = {};
                        // dados[Constantes
                        //     .paramatrosTelaLetraUnir] =
                        //     sa;
                        // Navigator
                        //     .pushReplacementNamed(
                        //   context,
                        //   Constantes
                        //       .rotaTelaListagemLetraUnir,
                        //   arguments:
                        //   dados,
                        // );
                      },
                      child: Text(Textos.btnCriarLetraTexto,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  )
                ],
              )
              ],
            ),
          ),
        ));
  }
}
