import 'package:flutter/material.dart';

class WidgetListagemVideos extends StatefulWidget {
  WidgetListagemVideos({Key? key, required this.resultadoLinks})
      : super(key: key);

  List<Map<String, String>> resultadoLinks = [];

  @override
  State<WidgetListagemVideos> createState() => _WidgetListagemVideosState();
}

class _WidgetListagemVideosState extends State<WidgetListagemVideos> {
  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: widget.resultadoLinks.length,
      itemBuilder: (context, index) {
        // variaveis vao receber o valor do map
        String nomeMusica = widget.resultadoLinks.elementAt(index).keys.toString();
        String linkMusica = widget.resultadoLinks.elementAt(index).values.toString();
        // removendo caracteres que nao sao necessarios
        nomeMusica = nomeMusica.replaceAll('(AP7Wnd">', "").replaceAll(")", "");
        linkMusica = linkMusica.replaceAll("(", "").replaceAll(")", "");
        return ListTile(
          iconColor: Colors.greenAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.link),
              SizedBox(
                width: larguraTela * 0.7,
                child: Text(
                    // removendo texto desnecessario para exibicao
                    nomeMusica,
                    textAlign: TextAlign.center),
              )
            ],
          ),

          onTap: () {
            Map dados = {};
            print(nomeMusica);
            print(linkMusica);
          }, // Handle your onTap here.
        );
      },
    );
  }
}
