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
            leading: const Image(image:  AssetImage('assets/imagens/logo_programa.png'),width: 40,height: 40,),
          ),
          body: SizedBox(
            width: larguraTela,
            height: alturaTela,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    width: larguraTela,
                    child: Text(
                      textAlign: TextAlign.center,
                      Textos.descricaoTelaInicial,
                      style: const TextStyle(fontSize: 20),
                    )),
                SizedBox(
                  height: alturaTela*0.8,
                  width: larguraTela,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      // Container(
                      //   margin: const EdgeInsets.all(10),
                      //   width: 200,
                      //   height: 80,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.pushReplacementNamed(
                      //         context,
                      //         Constantes.rotaTelaDividirTexto,
                      //       );
                      //     },
                      //     child: Text(Textos.btnCriarLetraTexto,
                      //         textAlign: TextAlign.center,
                      //         style: const TextStyle(
                      //           fontSize: 20,
                      //         )),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
