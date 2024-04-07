import 'dart:async';
import 'package:home_automation/utils.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'server.dart' if (dart.libary.html) 'browser.dart' as mqttsetup;
class MqttPublisher {
  final String brokerIp;
  final String topic;
  late String id;
  final mqtt.MqttQos qos;
  final int port;
  late var client;
  bool retain;
  Future<bool> sendMessage(String message) async {
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();
    builder.addString(message);
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    print("Attempting to plublish message ${[message]} to $topic as $id");
    try {
      await client.publishMessage(
          topic, qos, builder.payload!); //.timeout(Duration(seconds: 10));
      client.disconnect();
      print("Connection success. Published message");
      return true;
    } on mqtt.ConnectionException {
      print("Connection failure. Could not send mesage!");
      return false;
    }
  }
  MqttPublisher({
    this.brokerIp = /*'192.168.0.28'*/ '192.168.43.202',
    this.port = 5002,
    required this.topic,
    this.qos = mqtt.MqttQos.atMostOnce,
    this.retain = true,
  }) {
    this.id = "publisher-${idGenerator()}";
    this.client = mqttsetup.setup(brokerIp, id, port);
    client.setProtocolV311();
    client.keepAlivePeriod = 60;
    final connMessage =
        mqtt.MqttConnectMessage().withClientIdentifier(id).startClean();
    client.connectionMessage = connMessage;
  }
}
class MqttStatusFetcher {
  // MQTT details
  late String statusTopic;
  late String id;
  final String brokerIp;
  final int port;
  final int timeout;
  late mqtt.MqttClient client;
  MqttStatusFetcher({
    this.brokerIp = "192.168.0.28",
    this.port = 5002,
    this.timeout = 10,
    required this.statusTopic,
  }) {
    this.statusTopic = "relay/$statusTopic/status";
    this.id = idGenerator();
  }
  void dispose() {
    this.client.disconnect();
  }
  void initiateClient() {
    // Initiate the MQTT client.
    this.client = mqttsetup.setup(brokerIp, id, port);
    this.client.setProtocolV311();
    this.client.keepAlivePeriod = 2;
    this.client.disconnectOnNoResponsePeriod = 1;
    this.client.autoReconnect = true;
    void onConnected() {
      print("MQTT client ($id) is now connected to broker.");
    }
    void onAutoReconnected() {
      print("MQTT client ($id) has reconnected to broker.");
    }
    void onDisconnected() {
      print("MQTT client ($id) has been disconnected to broker.");
    }
    void onSubscribed(String topic) {
      print("MQTT client ($id) is now subscribed to $topic.");
    }
    this.client.onConnected = onConnected;
    this.client.onDisconnected = onDisconnected;
    this.client.onAutoReconnected = onAutoReconnected;
    this.client.onSubscribed = onSubscribed;
    final connMessage =
        mqtt.MqttConnectMessage().withClientIdentifier(id).startClean();
    this.client.connectionMessage = connMessage;
  }
  Stream<int> streamStatus() async* {
    print("Streaming status from MQTT broker");
    try {
      await this.client.connect();
    } on Exception catch (e) {
      print('MQTT client exception - $e');
      this.client.doAutoReconnect();
    }
    this.client.subscribe("$statusTopic", mqtt.MqttQos.atMostOnce);
    final snapshots = this.client.updates!;
    await for (final snapshot in snapshots) {
      final recMess = snapshot[0].payload as mqtt.MqttPublishMessage;
      final pt = mqtt.MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      yield int.parse(pt);
    }
  }
// Get.defaultDialog(
//                                     barrierDismissible: false,
//                                     title: "Switch to Firebase?",
//                                     titleStyle: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.bold),
//                                     titlePadding:
//                                         EdgeInsets.only(top: kDefaultPadding),
//                                     content: Padding(
//                                         padding:
//                                             EdgeInsets.all(kDefaultPadding / 2),
//                                         child: Text(
//                                           "Unable to locally toggle via your Raspberry Pi (MQTT). This usually means the Pi is offline or you are out of range of your home's network. To fix this, commands will now be sent online via Firebase.",
//                                           style: GoogleFonts.poppins(),
//                                           textAlign: TextAlign.justify,
//                                         )),
//                                     textCancel: "Cancel",
//                                     textConfirm: "Confirm",
//                                     confirmTextColor: Colors.white,
//                                     // onCancel: () {
//                                     //   setState(() {});
//                                     // },
//                                     // cancel: IconButton(
//                                     //     onPressed: () {},
//                                     //     icon: Icon(Icons.cancel_rounded)),
//                                     onConfirm: () {
//                                       setState(() {
//                                         isAcknowledged = true;
//                                       });
//                                       rtdb.asReference
//                                           .update({"status": boolToInt(value)});
//                                       Navigator.of(Get.overlayContext!,
//                                               rootNavigator: true)
//                                           .pop();
//                                     });
}