import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:senturionlettersg/Uteis/constantes.dart';
import 'package:senturionlettersg/Uteis/paleta_cores.dart';
import 'package:senturionlettersg/Uteis/textos.dart';

import 'salvarPDF/SavePDFMobile.dart'
    if (dart.library.html) 'salvarPDF/SavePDFWeb.dart';

class GerarPDF {
  List<dynamic> letraCompleta;
  String nomeLetra;
  bool exibirLogo;

  GerarPDF(
      {required this.letraCompleta,
      required this.nomeLetra,
      required this.exibirLogo});

  gerarPDF() async {
    final pdfLib.Document pdf = pdfLib.Document();
    //definindo que a variavel vai receber o caminho da
    // imagem para serem exibidas
    final image = (await rootBundle.load('assets/imagens/logo_adtl.png'))
        .buffer
        .asUint8List();
    final imageGeracaoFire =
        (await rootBundle.load('assets/imagens/logo_geracao_fire.png'))
            .buffer
            .asUint8List();

    final imageLogo =
        (await rootBundle.load('assets/imagens/logo_programa.png'))
            .buffer
            .asUint8List();
    //adicionando a pagina ao pdf
    pdf.addPage(pdfLib.MultiPage(
        //definindo formato
        margin:
            const pdfLib.EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
        //CABECALHO DO PDF
        header: (context) => pdfLib.Container(
              alignment: pdfLib.Alignment.center,
              child: pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceAround,
                children: [
                  pdfLib.Container(
                    height: 60,
                    width: 60,
                    child: pdfLib.LayoutBuilder(
                      builder: (context, constraints) {
                        if (exibirLogo) {
                          return pdfLib.Image(
                              pdfLib.MemoryImage(imageGeracaoFire),
                              width: 60,
                              height: 60);
                        } else {
                          return pdfLib.Container();
                        }
                      },
                    ),
                  ),
                  pdfLib.Container(
                    width: 200,
                    child: pdfLib.Text(nomeLetra,
                        textAlign: pdfLib.TextAlign.center,
                        style: pdfLib.TextStyle(
                            fontWeight: pdfLib.FontWeight.bold)),
                  ),
                  pdfLib.Container(
                    width: 60,
                    height: 100,
                    child: pdfLib.Column(children: [
                      pdfLib.Image(pdfLib.MemoryImage(image),
                          width: 50, height: 50),
                      pdfLib.Text(Textos.nomeIgreja,
                          textAlign: pdfLib.TextAlign.center),
                    ]),
                  ),
                ],
              ),
            ),
        //RODAPE DO PDF
        footer: (context) => pdfLib.Column(children: [
              pdfLib.Container(
                  padding: const pdfLib.EdgeInsets.only(
                      left: 0.0, top: 10.0, bottom: 0.0, right: 0.0),
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Container(
                    alignment: pdfLib.Alignment.centerRight,
                    child: pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                        children: [
                          pdfLib.Text(Textos.txtGeradoApk,
                              textAlign: pdfLib.TextAlign.center),
                          pdfLib.SizedBox(width: 10),
                          pdfLib.Image(pdfLib.MemoryImage(imageLogo),
                              width: 20, height: 20),
                        ]),
                  )),
            ]),
        pageFormat: PdfPageFormat.a4,
        orientation: pdfLib.PageOrientation.portrait,
        //CORPO DO PDF
        build: (context) => [
              pdfLib.Container(
                alignment: pdfLib.Alignment.center,
                child: pdfLib.ListView.builder(
                    itemBuilder: (context, index) {
                      return pdfLib.Text(
                          style: const pdfLib.TextStyle(
                            fontSize: 14,
                          ),
                          letraCompleta
                              .elementAt(index)
                              .toString()
                              .replaceAll("</p>", "\n\n")
                              .replaceAll(
                                  Constantes.stringPularLinhaSlide, ""));
                    },
                    itemCount: letraCompleta.length),
              )
            ]));

    List<int> bytes = await pdf.save();
    salvarPDF(bytes, '$nomeLetra.pdf');
  }
}
