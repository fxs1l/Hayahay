import 'package:flutter/material.dart';
import 'package:home_automation/constants.dart';

class ChosenDeviceType with ChangeNotifier {
  String chosenDeviceType = 'lights';
  String chosenRoom = '';
  Color _chosenForeground = Colors.blue;
  Color _chosenBackground = Colors.white;
  Color _notChosenBackground = Colors.white;
  Color _notChosenForeground = lightBlue;
  void setChosenRoom(String newRoom) {
    chosenRoom = newRoom;
    notifyListeners();
  }
  void setChosenDeviceType(String newDevice) {
    chosenDeviceType = newDevice;
    notifyListeners();
  }
  Color setChosenBackground(String type) {
    if (type == chosenDeviceType) {
      return _chosenBackground;
    } else return _notChosenBackground;
  }
  Color setChosenForeground(String type) {
    if (type == chosenDeviceType) {
      return _chosenForeground;
    } else return _notChosenForeground;
  }
}