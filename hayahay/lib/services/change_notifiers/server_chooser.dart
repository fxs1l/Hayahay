import 'package:flutter/cupertino.dart';
class ServerChooser with ChangeNotifier {
  bool local = true;
  void useFirebase() {
    local = false;
    print("Using Firebase");
    notifyListeners();
  }
  void useMqtt() {
    local = true;
    print("Using Mqtt");
    notifyListeners();
  }
}