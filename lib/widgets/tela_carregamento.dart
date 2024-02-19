import 'package:flutter/material.dart';
import 'package:senturionlettersg/Uteis/textos.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';

class TelaCarregamento extends StatelessWidget {
  const TelaCarregamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.all(10),
        width: larguraTela * 0.9,
        height: 200,
        child: Card(
          color: Colors.white,
          elevation: 1,
          shape: const RoundedRectangleBorder(
            side: BorderSide(width: 1,color: PaletaCores.corAzulMagenta),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Textos.txtTelaCarregamento,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: PaletaCores.corAzulMagenta,
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(PaletaCores.corCastanho),
                  strokeWidth: 3.0,
                )
              ],
            ),
          ),
        ));
  }
}
