extension NewLines on String {
  String get removeExtraNewLines => replaceAll(RegExp(r'\n{2,}'), ' ');
}
