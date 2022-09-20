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
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaPesquisa);
                    },
                    child: Text(Textos.btnTelaPesquisa,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
