import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/constants.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      elevation: 6,
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: size.width,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: appLogo,
                    ),
                  ),
                ),
              ),
            ),
            DrawerItemCard(
              text: 'Schedules',
              function: () {},
              icon: Icons.calendar_month_rounded,
            ),
            DrawerItemCard(
              text: 'Statistics',
              function: () {},
              icon: Icons.show_chart_rounded,
            ),
            DrawerItemCard(
              text: 'Settings',
              function: () {},
              icon: Icons.settings,
            ),
            DrawerItemCard(
              text: 'About',
              function: () {},
              icon: Icons.info_outline_rounded,
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class DrawerItemCard extends StatelessWidget {
  DrawerItemCard({
    Key? key,
    required this.text,
    required this.function,
    required this.icon,
  }) : super(key: key);
  final String text;
  final Function function;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0.5,
        margin: EdgeInsets.only(bottom: 1),
        child: InkWell(
          focusColor: Colors.blue,
          onTap: function(),
          child: Padding(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding),
                  child: AutoSizeText(
                    text,
                    textAlign: TextAlign.center,
                    minFontSize: 16,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}