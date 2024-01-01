extension NewLines on String {
  String get removeManyNewLines => replaceAll(RegExp(r'\n{2,}'), ' ');
}
