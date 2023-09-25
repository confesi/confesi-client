import 'package:flutter/cupertino.dart';

class PrimaryTabControllerService extends ChangeNotifier {
  int tabIdx;

  PrimaryTabControllerService({this.tabIdx = 0});

  void setTabIdx(int index) {
    tabIdx = index;
    notifyListeners();
  }
}
