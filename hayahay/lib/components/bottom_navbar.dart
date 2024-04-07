import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/constants.dart';
import 'package:home_automation/services/change_notifiers/page_selector.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key}) : super(key: key);
  State<BottomNavBar> createState() => _BottomNavBarState();
}
class _BottomNavBarState extends State<BottomNavBar> {
  // the other one was context.watch()
  void _onItemTapped(int index) {
    if (index != context.read<PageService>().selectedIndex) {
      context.read<PageService>().selectedIndex = index;
    }
  }
  //GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: context.read<PageService>().selectedIndex,
      height: 50,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.blue,
      onTap: (index) {
        _onItemTapped(index);
      },
      items: <Widget>[
        Icon(
          CustomIcons.door_open,
          size: 14,
          color: context.read<PageService>().setColor(0),
        ),
        Icon(
          Icons.gamepad_rounded,
          size: 16,
          color: context.read<PageService>().setColor(1),
        ),
        Icon(
          CustomIcons.terminal,
          size: 12,
          color: context.read<PageService>().setColor(2),
        ),
      ],
    );
  }
}