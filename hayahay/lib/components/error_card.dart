import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class ErrorCard extends StatelessWidget {
  //final String errorType;
  final double elevation;
  final String errorMessage;
  ErrorCard({Key? key, this.elevation = 1.0, required this.errorMessage})
      : super(key: key);
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shadowColor: lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Expanded(
            flex: 4,
            child: Image.asset(
              'assets/images/under_construction.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                errorMessage,
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(),
              ),
            ),
          ),
        ]),
    ));
  }
}
