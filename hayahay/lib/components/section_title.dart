import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
class SectionTitle extends StatelessWidget {
  SectionTitle({
    required this.title,
    this.color,
    this.underlineColor,
  });
  final String title;
  final Color? underlineColor;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kDefaultPadding / 2,
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
      ),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(
            text: title,
            color: color,
            underlineColor: underlineColor,
          ),
          // Spacer(),
        ],
      ),
    );
  }
}
class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    required this.text,
    this.color,
    this.underlineColor,
  });
  final String text;
  final Color? color;
  final Color? underlineColor;
  @override
  Widget build(BuildContext context) {
    // Default color values
    Color defaultColor = Colors.blue;
    Color defaultUnderlineColor = Colors.blue;
    // Use color from parameter values if available
    if (color != null) {
      defaultColor = color!;
    }
    if (underlineColor != null) {
      defaultUnderlineColor = underlineColor!;
    }
    return Container(
      height: 40,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: AutoSizeText(text,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: defaultColor,
                  ),
                )),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(bottom: kDefaultPadding / 3, left: 1),
              height: 4,
              color: defaultUnderlineColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}