import 'package:flutter/material.dart';
import 'package:home_automation/rooms/details/components/body.dart';
class DetailsScreen extends StatelessWidget {
  DetailsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        name: name,
      ),
    );
  }
}