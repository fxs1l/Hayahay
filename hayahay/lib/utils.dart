import 'package:flutter/material.dart';
import 'package:home_automation/models/device.dart';
import 'package:home_automation/models/room.dart';
String convertToTitleCase(String text) {
  if (text.length <= 1) {
    return text.toUpperCase();
  }
  final List<String> words = text.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);
      return '$firstLetter$remainingLetters';
    }
    return '';
  });
  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}
  
extension CapitalizedStringExtension on String {
  String toTitleCase() {
    return convertToTitleCase(this);
  }
}

int boolToInt(bool bool) {
  if (bool) return 1;
  return 0;
}

String iconConverter(String type) {
  if (type.contains("light"))
    return "lights_on";
  else if (type.contains("led"))
    return "led";
  else if (type.contains("RCWL"))
    return "rcwl";
  else if (type.contains("tv"))
    return "tv";
  else if (type.contains("fire"))
    return "fire";
  else if (type.contains("smoke")) return "smoke";
  return "none";
}
String statusConverter(bool value) {
  if (value)
    return "DETECTED";
  else
    return "NONE";
}
Color colorConverter(bool value) {
  if (value)
    return Colors.deepOrange;
  else
    return Colors.green;
}
String setRoomImage(String name) {
  String assetLocation = 'assets/images/unknown_room.png';
  if (name.contains('living')) {
    assetLocation = 'assets/images/living_room.png';
  } else if (name.contains('bed')) {
    assetLocation = 'assets/images/bed_room.png';
  } else if (name.contains('kitchen')) {
    assetLocation = 'assets/images/kitchen.png';
  } else if (name.contains('garage')) {
    assetLocation = 'assets/images/garage.png';
  } else if (name.contains('porch')) {
    assetLocation = 'assets/images/porch.png';
  } else if (name.contains('garden')) {
    assetLocation = 'assets/images/garden.png';
  } else if (name.contains('bathroom')) {
    assetLocation = 'assets/images/bathroom.png';}
  return assetLocation;
  }
List<AssetImage> setSwitchImages(String type) {
  if (type.contains("lights")) {
    return [
      AssetImage('assets/icons/lights_on.png'),
      AssetImage('assets/icons/lights_off.png')
    ];
    // } else if (type.contains("led")) {
    // } else if (type.contains("aircon") || type.contains("ac")) {
    // } else if (type.contains()) {
  } else {
    return [
      AssetImage("assets/icons/none.png"),
      AssetImage("assets/icons/none.png")
    ];
  }
}
String boolToString(bool bool) {
  if (bool) {
    return '1';
  }
  return '0';
}
List<Room> roomsProcessor(AsyncSnapshot snapshot) {
  final Map<String, dynamic>? rooms =
      Map<String, dynamic>.from(snapshot.data.snapshot.value);
  final List<Room> roomsList = [];
  rooms!.forEach((name, json) {
    final Room room = Room.fromJson(json, name);
    roomsList.add(room);
  });
  return roomsList;
}
List<Device> devicesProcessor(AsyncSnapshot snapshot) {
  final List jsonList = snapshot.data.snapshot.value;
  jsonList.forEach((stringJson) {
    // Map<String, dynamic> jsonDevice = json.decode(stringJson);
    // Device newDevice = Device.fromJson(json: jsonDevice);
  });
  // Map<String, dynamic>.from(snapshot.data.snapshot.value);
  //
  // devices!.forEach((deviceType, json) {
  //   final Device device = Device.fromJson(json: json, deviceType: deviceType);
  //   roomsList.add(device);
  // });
  return <Device>[];
}
String idGenerator() {
  final now = DateTime.now();
  return "app-" + now.microsecondsSinceEpoch.toString();
}