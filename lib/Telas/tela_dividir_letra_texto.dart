import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/metodos_auxiliares.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';

class TelaDividirLetraTexto extends StatefulWidget {
  const TelaDividirLetraTexto({Key? key}) : super(key: key);

  @override
  State<TelaDividirLetraTexto> createState() => _TelaDividirLetraTextoState();
}

class _TelaDividirLetraTextoState extends State<TelaDividirLetraTexto> {
  Estilo estilo = Estilo();
  final chaveFormulario = GlobalKey<FormState>();
  TextEditingController controllerPesquisa = TextEditingController();
  TextEditingController controllerNomeLetra = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: chaveFormulario,
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20.0, top: 10.0),
                              width: larguraTela,
                              child: Text(
                                textAlign: TextAlign.center,
                                Textos.descricaoDividirLetraTexto,
                                style: const TextStyle(fontSize: 20),
                              )),
                          SizedBox(
                            width: larguraTela * 0.7,
                            height: alturaTela * 0.1,
                            child: TextFormField(
                              controller: controllerNomeLetra,
                              decoration: InputDecoration(
                                  hintText: Textos.hintTextFieldNomeLetra),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Textos.erroCampoVazio;
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20.0, top: 10.0),
                              width: larguraTela*0.6,
                              child: Text(
                                textAlign: TextAlign.center,
                                Textos.descricaoDividirLetraTextoAddEstrofe,
                                style: const TextStyle(fontSize: 20),
                              )),
                          SizedBox(
                              width: larguraTela * 0.7,
                              height: alturaTela * 0.5,
                              child: TextFormField(
                                maxLines: 100,
                                controller: controllerPesquisa,
                                decoration: InputDecoration(
                                    hintText: Textos.hintDividirLetraTexto),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return Textos.erroCampoVazio;
                                  }
                                  return null;
                                },
                              )),
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 100,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (chaveFormulario.currentState!.validate()) {
                                  String letraFormadata = controllerPesquisa
                                      .text
                                      .replaceAll("\n\n", "<p>")
                                      .replaceAll("\n", "<br>");
                                  List<String> letraCompleta =
                                      MetodosAuxiliares.dividirLetraEstrofes(
                                          letraFormadata.split("<p>"));
                                  Map dados = {};
                                  dados[Constantes.parametrosTelaLinkLetra] =
                                      "";
                                  dados[Constantes
                                          .parametroTelaDividirLetraTexto] =
                                      Constantes.parametroTelaDividirLetraTexto;
                                  dados[Constantes.parametrosTelaLetra] =
                                      letraCompleta;
                                  dados[Constantes.parametrosTelaNomeLetra] =
                                      controllerNomeLetra.text;
                                  dados[Constantes.parametrosTelaModelo] =
                                      Constantes.logoGeral;
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Constantes.rotaTelaListagemLetra,
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
                      ),
                    ),
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
