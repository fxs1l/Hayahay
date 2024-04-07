import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/components/error_card.dart';
import 'package:home_automation/models/device.dart';
import 'package:home_automation/services/change_notifiers/broker_notifier.dart';
import 'package:home_automation/services/realtime_database.dart';
import 'package:home_automation/services/change_notifiers/chosen_device_type.dart';
import 'package:home_automation/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/services/mqtt.dart';
import 'package:home_automation/services/change_notifiers/server_chooser.dart';
import 'package:home_automation/utils.dart';
import 'package:provider/provider.dart';
import 'package:home_automation/constants.dart';
class ControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Side Buttons
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    color: lightBlue,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              // Iterate through list and display the device types
              for (String type in deviceTypes) DeviceSelectorButton(type: type),
            ],
          ),
        ),
        // Display the controls
        ControlsBody(),
      ],
    );
  }
}

class ControlsBody extends StatefulWidget {
  @override
  State<ControlsBody> createState() => _ControlsBodyState();
}

class _ControlsBodyState extends State<ControlsBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(10, 6),
              blurRadius: 1,
              color: kPrimaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: Card(
          elevation: 0.75,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: Stack(
                  children: [
                    SectionTitle(
                        title: context
                            .watch<ChosenDeviceType>()
                            .chosenDeviceType
                            .toUpperCase()),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: Icon(Icons.restart_alt_rounded),
                              color: kPrimaryColor,
                              splashRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: ControlsBuilder()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AutoSizeText("Server: "),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: kDefaultPadding,
                        bottom: kDefaultPadding / 2,
                        left: kDefaultPadding / 2 + 5),
                    child: Transform.scale(
                      scale: 2,
                      child: Switch(
                          value: context.watch<ServerChooser>().local,
                          activeTrackColor: lightBlue,
                          activeColor: Color.fromARGB(255, 245, 245, 245),
                          activeThumbImage: AssetImage("assets/icons/rpi.png"),
                          inactiveThumbImage:
                              AssetImage("assets/icons/firebase.png"),
                          onChanged: (bool value) {
                            String msg = '';
                            Color bgColor = Colors.red;
                            if (value) {
                              context.read<ServerChooser>().useMqtt();
                              msg = 'Switched to local (MQTT) server.';
                            } else {
                              context.read<ServerChooser>().useFirebase();
                              msg = 'Switched to online (Firebase) server';
                              bgColor = Colors.amber;
                            }
                            Fluttertoast.showToast(
                                msg: msg,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: bgColor,
                                textColor: Colors.white,
                                fontSize: 16.0,
                                webPosition: "center");
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ControlsBuilder extends StatelessWidget {
  final RealtimeDatabase rtdb = RealtimeDatabase();
  Future<Device> getDevice(
      Future<DataSnapshot> future, String deviceType) async {
    final snapshot = await future;
    Device device =
        Device.fromJson(json: snapshot.value as Map, type: deviceType);
    return device;
      }
  @override
  Widget build(BuildContext context) {
    final roomName = context.read<ChosenDeviceType>().chosenRoom;
    final chosenDevice = context.watch<ChosenDeviceType>().chosenDeviceType;
    rtdb.setPath("data");
    return StreamBuilder(
      stream: rtdb.asReference!.child('rooms/$roomName/$chosenDevice').onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasData && snapshot.data.snapshot.value != null) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Column(
                children: [
                  CircularProgressIndicator.adaptive(),
                  AutoSizeText(
                    "Switching to ${chosenDevice}",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              );
            case ConnectionState.active:
              final List data = snapshot.data.snapshot.value;
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(kDefaultPadding),
                itemCount: data.length,
                itemBuilder: ((context, index) {
                  return FutureBuilder(
                    future: getDevice(
                        rtdb.asReference!
                            .child("devices/$chosenDevice/${data[index]}")
                            .get(),
                        chosenDevice),
                    builder: ((context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error parsing device");
                      } else {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return Column(
                              children: [
                                CircularProgressIndicator(),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: AutoSizeText(
                                    "Loading ${data[index]} ...",
                                    style: GoogleFonts.poppins(),
                                    minFontSize: 8,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            );
                          case ConnectionState.done:
                            Device device = snapshot.data as Device;
                            // return Text("${device.id}");
                            final sf = MqttStatusFetcher(
                                statusTopic: device.relay.toString());
                            sf.initiateClient();
                            return DeviceControllerCard(
                              device: device,
                              sf: sf,
                            );
                        }
                      }
                    }),
                  );
                }),
              );
            case ConnectionState.done:
              return Container();
          }
        } else {
          final String _warningMessage =
              "There are no $chosenDevice configured in the database. Please setup the Raspberry Pi.";
          return ErrorCard(
            errorMessage: _warningMessage,
            elevation: 0,
          );
          // throw UnimplementedError();
        }
      },
    );
  }
}
class DeviceControllerCard extends StatefulWidget {
  final Device device;
  final MqttStatusFetcher sf;
  DeviceControllerCard({required this.device, required this.sf});
  @override
  State<DeviceControllerCard> createState() => _DeviceControllerCardState();
}
class _DeviceControllerCardState extends State<DeviceControllerCard> {
  late Stream<int> _latestMqttStream;
  // bool _isAcknowledged = false;
  RealtimeDatabase _rtdb = RealtimeDatabase();
  StreamController _controller = StreamController();
  String getServer() {
    String server = '';
    context.read<ServerChooser>().local ? server = "LOCAL" : server = "ONLINE";
    return server;
  }
  Future<String> showAfter() async {
    return Future.delayed(Duration(seconds: 5), () {
      return "";
    });
  }
  void sendUpdate(bool value) async {
    bool useMqtt = context.read<ServerChooser>().local;
    if (useMqtt) {
      bool wasSent = await MqttPublisher(
        topic: "relay/${widget.device.relay}",
      ).sendMessage(boolToString(value));
      wasSent
          ? print("Sent local successful")
          : Fluttertoast.showToast(
              msg: "Error sending update to local (MQTT) server",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
              webPosition: "center");
    } else {
      print("updating database");
      final newdb = RealtimeDatabase();
      newdb.setPath(
          "data/devices/${widget.device.deviceType}/${widget.device.id}");
      newdb.update({"status": boolToInt(value)});
    }
  }
  @override
  void initState() {
    super.initState();
    _latestMqttStream = widget.sf.streamStatus();
    String statusPath =
        "data/devices/${widget.device.deviceType}/${widget.device.id}/status";
    context.read<ServerChooser>().local
        ? _controller.addStream(_latestMqttStream)
        : _controller.addStream(_rtdb.streamStatus(statusPath));
  }
  @override
  void dispose() {
    super.dispose();
    widget.sf.dispose();
    _controller.close();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      child: Card(
        elevation: 0.5,
        child: Column(
          // fit: StackFit.expand,
          children: [
            StreamBuilder(
              stream: _controller.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  final List<AssetImage> assets =
                      setSwitchImages(widget.device.deviceType);
                  if (!widget.device.analog) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultPadding,
                              left: kDefaultPadding,
                              right: kDefaultPadding),
                          child: Transform.scale(
                            scale: 2,
                            child: Switch(
                              activeThumbImage: assets[0],
                              inactiveThumbImage: assets[1],
                              value: data == 1,
                              onChanged: (bool value) {
                                sendUpdate(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 10,
                          child: Transform.scale(
                            scale: 1.25,
                            child: Slider(
                                label: "$data %",
                                divisions: 4,
                                max: 100,
                                value: data.toDouble(),
                                onChanged: (value) {},
                                onChangeEnd: (value) async {
                                  Fluttertoast.showToast(
                                      msg: "Unimplemented",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                      webPosition: "center");
                                }),
                          ),
                        ),
                        Spacer()
                      ],
                    );
                  }
                } else {
                  // Timer.run(Duration(seconds: 5),)
                  return FutureBuilder(
                    future: showAfter(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        print(
                            "Displaying Timeout screen since no data was received after 5 seconds");
                        return InkWell(
                          onTap: () {
                            setState(() {});
                            _controller.add(null);
                            // setState(){};
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(Icons.warning_amber_rounded),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    "Loading from ${getServer()} server took too long. Would you like to retry?",
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
                // return Text(snapshot.data.toString());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(kDefaultPadding / 2),
                    child: AutoSizeText(
                      'Identifier:${widget.device.id}',
                      maxLines: 1,
                      minFontSize: 8,
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
class DeviceSelectorButton extends StatelessWidget {
  const DeviceSelectorButton({
    required this.type,
  });
  final String type;
  @override
  Widget build(BuildContext context) {
    final String image = "assets/icons/" + type + ".png";
    final borderShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0));
    return Expanded(
      flex: 2,
      child: Container(
        //height: size.width * 0.20,
        //width: size.width * 0.20,
        margin: EdgeInsets.all(kDefaultPadding),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(5, 5),
              blurRadius: 0.5,
              color: kPrimaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: InkWell(
          customBorder: borderShape,
          hoverColor: lightBlue,
          splashColor: Colors.blue,
          onTap: () {
            context.read<ChosenDeviceType>().setChosenDeviceType(type);
          },
          child: Card(
            // clipBehavior: Clip.antiAlias,
            color: Provider.of<ChosenDeviceType>(context)
                .setChosenBackground(type),
            shape: borderShape,
            //shadowColor: Colors.blue,
            elevation: 0.75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                image,
                // width: 50,
                // height: 50,
                color: Provider.of<ChosenDeviceType>(context)
                    .setChosenForeground(type),
              ),
            ),
          ),
        ),
      ),
    );
  }
}