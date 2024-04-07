import 'package:flutter/material.dart';
import 'package:home_automation/commands/commands_page.dart';
import 'package:home_automation/devices/devices_page.dart';
import 'package:home_automation/rooms/rooms_page.dart';
class PageService with ChangeNotifier {
  int _selectedIndex = 0;
  List<Widget> _pages = [RoomsPage(), DevicesPage(), CommandsPage()];
  Color _chosenColor = Colors.white;
  Color _notChosenColor = Colors.grey;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    this._selectedIndex = index;
    notifyListeners();
  }
  List<Widget> get pages => _pages;
  Color setColor(int index) {
    if (index == _selectedIndex) {
      return _chosenColor;
    }
    return _notChosenColor;
  }
}