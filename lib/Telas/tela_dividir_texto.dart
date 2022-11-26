import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/estilo.dart';
import 'package:senturionlettersg/widgets/tela_carregamento.dart';

class TelaDividirTexto extends StatefulWidget {
  const TelaDividirTexto({Key? key})
      : super(key: key);


  @override
  State<TelaDividirTexto> createState() => _TelaDividirTextoState();
}

class _TelaDividirTextoState extends State<TelaDividirTexto> {
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
                                        height: alturaTela*0.5,
                                        child: Form(
                                          key: chaveFormulario,
                                          child: TextField(
                                            onSubmitted: ((value) {
                                              print("sfdsf");
                                            }),
                                            controller: controllerPesquisa,
                                            decoration: InputDecoration(
                                                hintText: Textos
                                                    .hintBarraPesquisaLetra),
                                            // validator: (value) {
                                            //   if (value!.isEmpty) {
                                            //     return Textos.erroCampoVazio;
                                            //   }
                                            //   return null;
                                            // },
                                          ),
                                        )),
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: FloatingActionButton(
                                          enableFeedback: true,
                                          backgroundColor: Colors.white,
                                          hoverColor: PaletaCores.corCastanho,
                                          onPressed: () async {
                                            print(controllerPesquisa.text);

                                          },
                                          child: const Icon(
                                            Icons.search_rounded,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ))
                                  ],
                                ),
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
