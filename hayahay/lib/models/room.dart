class Room {
  final String name;
  List? lights;
  List? appliances;
  List? sensors;
  List? cameras;
  Room({
    required this.name,
    this.lights,
    this.appliances,
    this.sensors,
    this.cameras,
    //required this.deviceList,
  });
  Room.fromJson(Map<dynamic, dynamic> json, String name)
      : name = name,
        lights = json['lights'],
        appliances = json['appliances'],
        sensors = json['sensors'],
        cameras = json['cameras'];
}