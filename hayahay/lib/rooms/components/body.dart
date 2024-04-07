import 'package:flutter/material.dart';
import 'package:home_automation/components/section_title.dart';
import 'rooms_carousel.dart';
class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(title: "Rooms"),
          // TODO add search button here
          Expanded(
            flex: 4,
            child: RoomStreamBuilder(),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}