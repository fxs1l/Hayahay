import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation/components/section_title.dart';
import 'package:home_automation/services/mqtt.dart';
import 'package:home_automation/utils.dart';
import 'package:provider/provider.dart';
import '../../services/change_notifiers/temp.dart';
class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  final MqttPublisher mp = MqttPublisher(topic: "relay/mode/status");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SectionTitle(title: "Commands"),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<Manual>().switchMode();
                mp.sendMessage(boolToString(context.read<Manual>().manual));
                Fluttertoast.showToast(
                    msg: "Toggling",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                    webPosition: "center");
              },
              child: Text("Toggle manual/auto"),
            ),
          )
        ],
      ),
    );
  }
}