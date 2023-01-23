import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';

class TelaInicial extends StatelessWidget {
  TelaInicial({Key? key}) : super(key: key);

  Estilo estilo = Estilo();

  Widget botoesHome(BuildContext context, String tituloBtn) => Container(
        margin: const EdgeInsets.all(10),
        width: 250,
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            if (tituloBtn == Textos.btnLetraUnica) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaPesquisa,
                  arguments: true);
            } else if (tituloBtn == Textos.btnUnirLetras) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaPesquisa,
                  arguments: false);
            } else if (tituloBtn == Textos.btnCriarLetraTexto) {
              Navigator.pushReplacementNamed(
                context,
                Constantes.rotaTelaDividirLetraTexto,
              );
            }
          },
          child: Text(tituloBtn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Theme(
        data: estilo.estiloGeral,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Textos.nomeApp),
            leading: const Image(
              image: AssetImage('assets/imagens/logo_programa.png'),
              width: 40,
              height: 40,
            ),
          ),
          body: SizedBox(
            width: larguraTela,
            height: alturaTela,
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  width: larguraTela,
                  child: Text(
                    textAlign: TextAlign.center,
                    Textos.descricaoTelaInicial,
                    style: const TextStyle(fontSize: 20),
                  )),
              SizedBox(
                  height: alturaTela * 0.6,
                  width: larguraTela * 0.6,
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      children: [
                        botoesHome(context, Textos.btnLetraUnica),
                        botoesHome(context, Textos.btnUnirLetras),
                        botoesHome(context, Textos.btnCriarLetraTexto),
                      ],
                    ),
                  ))
            ]),
          ),
          bottomSheet: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              width: larguraTela,
              child: const Text(
                "Versão : ${Constantes.versaoApp}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 13,
                ),
              )),
        ));
  }
}
