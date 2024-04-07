import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
class RoomName extends StatelessWidget {
  const RoomName({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kDefaultPadding),
      child: Row(
        children: <Widget>[
          AutoSizeText(
            title,
            minFontSize: 26,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Spacer(),
        ],
      ),
    );
  }
}