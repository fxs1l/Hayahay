import 'package:flutter/material.dart';
import 'package:home_automation/components/appbar.dart';
import 'package:home_automation/components/bottom_navbar.dart';
import 'package:home_automation/components/drawer.dart';
import 'package:home_automation/services/change_notifiers/page_selector.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = context.watch<PageService>().pages;
    int selectedIndex = context.watch<PageService>().selectedIndex;
    return Scaffold(
      extendBody: true,
      //backgroundColor: lightBlue,
      appBar: GlobalAppBar(),
      drawer: SafeArea(child: NavDrawer()),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavBar(),
    );
  }
}