import 'package:flutter/cupertino.dart';

class CreateCommentService extends ChangeNotifier {
  bool isLoading = false;

  void clear() {
    isLoading = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
