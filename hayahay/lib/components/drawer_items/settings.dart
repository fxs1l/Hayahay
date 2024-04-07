import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SettingsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/coming_soon.png"),
            SizedBox(height: 20,),
            Text(
              'Stats Screen',
              style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ),
    );
  }
}