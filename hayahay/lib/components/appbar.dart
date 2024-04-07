import 'package:flutter/material.dart';
import 'header.dart';
class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    Key? key,
  }) : super(key: key);
  final double height = 80;
  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //     elevation: 0,
    //     leading: Builder(
    //         builder: (context) => IconButton(
    //             onPressed: () => Scaffold.of(context).openDrawer(),
    //             icon: Icon(Icons.menu_open_rounded))),
    //     title: Header());
    return Header();
  @override
  Size get preferredSize => Size.fromHeight(height);
  }
}