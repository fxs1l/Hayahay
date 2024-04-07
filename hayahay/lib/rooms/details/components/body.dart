import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'room_name.dart';
import 'control_panel.dart';
import 'package:home_automation/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Body extends StatelessWidget {
  const Body({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(flex: 10, child: ControlPanel()),
          Expanded(flex: 1, child: RoomName(title: name.toTitleCase())),
          // ButtomButtons
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                BottomButton(
                    title: 'Stats',
                    function: () {
                      Navigator.pop(context);
                    }),
                BottomButton(
                    title: 'Schedule',
                    function: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class BottomButton extends StatelessWidget {
  const BottomButton({
    required this.title,
    required this.function,
  });
  final String title;
  final Function function;
  @override
  Widget build(BuildContext context) {
    final String assetLocation = 'assets/icons/${title.toLowerCase()}.png';
    return Expanded(
      flex: 3,
      child: InkWell(
        child: Container(
          //width: size.width / 2,
          child: Card(
            margin: EdgeInsets.only(
              right: 5,
              left: 2.5,
            ),
            elevation: 0,
            color: Color.fromARGB(255, 143, 198, 243),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    assetLocation,
                    color: Colors.white,
                  ),
                ),
                AutoSizeText(
                  title,
                  minFontSize: 20,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          function();
        },
      ),
    );
  }
}