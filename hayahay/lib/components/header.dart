import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/constants.dart';
class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
          top: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 32,
              child: Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AutoSizeText(
                    appTitle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    minFontSize: 20,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AutoSizeText(
                    '($appVersion)',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    minFontSize: 1,
                    style: GoogleFonts.sourceCodePro(
                        textStyle: TextStyle(color: Colors.white)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                      width: 32,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 1)
          ],
        ),
      ),
    );
  }
}