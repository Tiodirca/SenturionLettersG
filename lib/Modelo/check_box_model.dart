class CheckBoxModel {
  CheckBoxModel(
      {required this.texto,
      required this.tituloLetra,
      this.idItem = 0,
      this.checked = false});

  String texto;
  String tituloLetra;
  int idItem;
  bool checked;
}
