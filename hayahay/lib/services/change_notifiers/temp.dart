import 'package:flutter/cupertino.dart';
class Manual with ChangeNotifier {
  bool manual = true;
  void switchMode() {
    manual = !manual;
    notifyListeners();
  }
}