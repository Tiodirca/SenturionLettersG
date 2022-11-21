import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/metodos_auxiliares.dart';

class ConteudoLetraWidget extends StatefulWidget {
  const ConteudoLetraWidget(
      {Key? key,
      required this.exibirLogo,
      required this.conteudoLetra,
      required this.tituloLetra})
      : super(key: key);
  final bool exibirLogo;
  final String tituloLetra;
  final String conteudoLetra;

  @override
  State<ConteudoLetraWidget> createState() => _ConteudoLetraWidgetState();
}

class _ConteudoLetraWidgetState extends State<ConteudoLetraWidget> {
  // Widget conteudoLetra(
  //     bool exibirLogo, String conteudoLetra, String tituloLetra) =>
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: MetodosAuxiliares.verificarTipoDispositivo() ? 200 : 200,
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
                      width: MetodosAuxiliares.verificarTipoDispositivo()
                          ? 25
                          : 30,
                      height: MetodosAuxiliares.verificarTipoDispositivo()
                          ? 25
                          : 30,
                      child: Visibility(
                        visible: widget.exibirLogo,
                        child: Image.asset(
                          'assets/imagens/logo_geracao_fire.png',
                        ),
                      )),
                  SizedBox(
                    width: MetodosAuxiliares.verificarTipoDispositivo()
                        ? 100
                        : 200,
                    child: Text(
                      widget.tituloLetra,
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
                    width:
                        MetodosAuxiliares.verificarTipoDispositivo() ? 25 : 30,
                    height:
                        MetodosAuxiliares.verificarTipoDispositivo() ? 25 : 30,
                    child: Image.asset(
                      'assets/imagens/logo_adtl.png',
                    ),
                  ),
                ],
              ),
              Text(
                  widget.conteudoLetra
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
        ));
  }
}
