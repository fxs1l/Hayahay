class Device {
  late String id;
  late dynamic status;
  late String room;
  late String deviceType;
  late int relay;
  bool analog = false;
  Device.fromJson({required Map<dynamic, dynamic> json, required type}) {
    this.id = json['id'];
    this.status = json['status'];
    this.room = json['room'];
    this.relay = json['relay'];
    if (json.containsKey('analog')) {
      this.analog = json['analog'];
    }
    this.deviceType = type;
  }
  bool toggle(String newStatus) {
    return true;
// class Lights extends Device {
//   final String deviceType = 'lights';
//   Lights.fromJson({required Map json}) : super.fromJson(json: json);
// }
  }
}