import 'package:flutter/material.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({Key? key}) : super(key: key);

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: SizedBox(
          height: alturaTela,
          width: larguraTela,
          //color: PaletaCores.corAzul,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                // Positioned(
                //     child: SizedBox(
                //         width: larguraTela,
                //         height: alturaTela - alturaBarraStatus - alturaAppBar,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             SizedBox(
                //               width: larguraTela * 0.9,
                //               height: alturaTela * 0.2,
                //               child: Image.asset(
                //                 "assets/imagens/logo_app.png",
                //               ),
                //             ),
                //             //const TelaCarregamento()
                //           ],
                //         )))
              ],
            ),
          )),
    );
  }
}
