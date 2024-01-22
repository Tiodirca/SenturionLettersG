class Textos {
  static String nomeApp = "Senturion Letters G";

  static String telaInicial = "";
  static String descricaoTelaInicial =
      "Selecione uma das opções abaixo para poder estar "
      "criando um arquivo de Power Point contendo a letra de uma música.";

  // string com o nome dos botoes
  static String btnLetraUnica = "Criar letra a partir de uma música";
  static String btnUnirLetras = "Criar letra a partir da união de duas músicas";
  static String btnCriarLetraTexto = "Criar letra a partir de um texto";

  static String btnEditar = "Editar";
  static String btnGerarArquivo = "Gerar Slide";
  static String btnBaixarPDF = "Baixar PDF";
  static String btnUsar = "Usar";
  static String btnTrocarModelo = "Trocar de Modelo";
  static String btnTrocarModeloNome = "Trocar de Modelo/Nome";
  static String btnSalvar = "Salvar";

  // string com o nome dos radio button
  static String radioButtonGeral = "Modelo Geral";
  static String radioButtonGeracaoFire = "Modelo Geração Fire";

  static String txtTelaCarregamento = "Aguarde Carregando";

  static String qtdSlides = "Quantidade de Slides :";

  // VARIAVEIS GLOBAIS
  static String nomeLetra = "Nome da Letra ";

  // TELA DE PESQUISA DE LINKS
  static String telaPesquisa = "Pesquisa de Letras";
  static String descricaoBarraPesquisaLetra =
      "Digite o nome da música que deseja pesquisar";
  static String labelBarraPesquisaLetra = "Digite o nome e o cantor da musica";
  static String hintBarraPesquisaLetra = "Ex: Divino Companheiro Mara Lima";
  static String descricaoListagemLinks =
      "Selecione um dos links para carregar a letra da musica";
  static String descricaoListagemLinksLetraUnir =
      "Adicione 2 Links na lista para poder estar unindo as letras das musicas";

  // TELA DE VISUALIZACAO DE LETRA
  static String telaVisualizacaoLetra = "Visualizar Letra Completa";
  static String descricaoTelaVisualizacaoLetra =
      "Aqui você pode visualizar a letra completa da musica, podendo editar conforme"
      " precisar e/ou gerar o arquivo de slides ";
  static String descricaoSelecaoLogo =
      "Selecione um modelo antes de visualizar a letra ";

  // TELA EDICAO DE LETRA
  static String telaEdicaoLetra = "Edição da Letra da musica";
  static String descricaoTelaEdicaoLetra =
      "Aqui você pode editar a letra, adicionar e/ou remover estrofes da música";
  static String sucessoAddSlide = "Sucesso ao adicionar slide";
  static String sucessoRemoSlide = "Sucesso ao remover slide";

  // TELA DE VISUALIZACAO LETRA UNIR
  static String telaVisualizacaoLetraUnir = "Visualizar Letras para Unir";
  static String descricaoTelaVisualizacaoLetraUnir =
      "Marque as estrofes que deseja adicionar na letra Final,"
      "para remover uma estrofe basta desmarcar a caixa de seleção";

  static String nomeLetraFinalUnir = "Nome Letra Final";
  static String hintTextFieldNomeLetra = "Digite o nome que a letra terá";

  // TELA DE LETRA TEXTO
  static String telaDividirLetraTexto = "";
  static String hintDividirLetraTexto = "Cole ou digite a letra aqui";
  static String descricaoDividirLetraTexto =
      "Copie e cole a mensagem de texto contendo a letra da música que deseja"
      "gerar o arquivo em Power Point para avançar";
  static String descricaoDividirLetraTextoAddEstrofe =
      "Para colocar o texto na linha de baixo pule para a proxima linha, para adicionar uma "
      "estrofe nova, pule a linha duas vezes,deixando um espaço entre uma estrofe e outra";


  static String nomeIgreja = "ADTL Parque São Carlos";
  static String txtGeradoApk = "Letra criada por Senturion Letters G";

  // ERROS
  static String erroPesquisaLetraUnir =
      "Infelizmente não foi possivel realizar a pesquisa de uma ou mais letras.";
  static String erroSelecaoLetraUnir =
      "Selecione pelo menos 2 links para poder estar prosseguindo ";
  static String erroLetraFinalVazia = "Adicione estrofes na letra final antes";
  static String erroNMaxLetrasUnir =
      "Você já selecionou o máximo de links possiveis, remova "
      "um deles para adicionar outro no lugar";
  static String erroPesquisaInvalida =
      "Infelizmente não foi possivel encontrar "
      "links para a sua pesquisa. verifique e tente novamente";
  static String erroCampoVazio = "Preencha o campo antes de prosseguir";
  static String erroSlideVazio =
      "Existe um ou mais slides sem conteudo, por favor preencha ou exclua-os";
  static String erroUmSlide =
      "Não é possivel remover o slide,pois a letra precisa conter pelo menos um slide";
  static String erroGerarArquivo =
      "Não foi possivel gerar o arquivo devido ao seguinte erro : ";
}
