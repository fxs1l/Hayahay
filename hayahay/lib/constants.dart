import 'package:flutter/material.dart';
const double kDefaultPadding = 20.0;
const Color kPrimaryColor = Colors.blue;
const Color lightBlue = Color.fromARGB(255, 152, 204, 253);
const Color lightGreen = Color.fromARGB(255, 195, 211, 198);
const Color darkGreen = Color.fromARGB(255, 63, 152, 125);
Image appLogo = Image.asset('assets/images/logo.png');
const appTitle = 'Home Assistant';
const appVersion = 'alpha v2';
const List<String> deviceTypes = ['lights', 'sensors', 'appliances', 'cameras'];

class CustomIcons {
  CustomIcons._();
  static const _kFontFam = 'CustomIcons';
  static const String? _kFontPkg = null;
  //static const IconData brush =IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData terminal =
      IconData(0xf120, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData door_open =
      IconData(0xf52b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}