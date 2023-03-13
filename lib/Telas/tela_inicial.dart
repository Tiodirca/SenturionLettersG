import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Estilo estilo = Estilo();
  bool exibirCaixaSelecao = false;

  Widget botoesHome(BuildContext context, double largura, double altura,
          String tituloBtn) =>
      Container(
        margin: const EdgeInsets.all(10),
        width: largura,
        height: altura,
        child: ElevatedButton(
          onPressed: () {
            if (tituloBtn == Textos.btnLetraUnica) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaPesquisa,
                  arguments: Constantes.tipoPesquisaUnica);
            } else if (tituloBtn == Textos.btnUnirLetras) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaPesquisa,
                  arguments: Constantes.tipoPesquisaDupla);
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
                        botoesHome(context, 250, 100, Textos.btnLetraUnica),
                        botoesHome(context, 250, 100, Textos.btnUnirLetras),
                        botoesHome(
                            context, 250, 100, Textos.btnCriarLetraTexto),
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
