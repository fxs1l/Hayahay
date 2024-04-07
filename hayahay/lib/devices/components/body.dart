import 'package:flutter/cupertino.dart';
import 'package:home_automation/components/section_title.dart';
class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> deviceTypes = ['lights', 'sensors', 'appliances', 'cameras'];
    return PageView(
      children: [
        for (String type in deviceTypes)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionTitle(title: "Devices[$type]"),
              // DevicesTileBuilder(type: type)
            ],
          ),
      ],
    );
  }
}