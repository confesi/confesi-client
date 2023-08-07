import 'package:flutter/cupertino.dart';

class CreateCommentService extends ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
