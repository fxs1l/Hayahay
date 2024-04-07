import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/components/error_card.dart';
import 'package:home_automation/rooms/details/details_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:home_automation/constants.dart';
import 'package:home_automation/utils.dart';
import 'package:home_automation/services/realtime_database.dart';
import 'package:provider/provider.dart';
import '../../models/room.dart';
import '../../services/change_notifiers/chosen_device_type.dart';
class RoomStreamBuilder extends StatefulWidget {
  @override
  State<RoomStreamBuilder> createState() => _RoomStreamBuilderState();
  }
class _RoomStreamBuilderState extends State<RoomStreamBuilder> {
  final RealtimeDatabase rtdb = RealtimeDatabase();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    rtdb.setPath("data/rooms");
    return StreamBuilder(
      stream: rtdb.asReference!.limitToLast(5).onValue,
      builder: ((context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              final String _warningMessage =
                  "There was an error connecting to the database. Please check your phone's wireless connection or if the Pi has been configured properly. Tap to retry connection.";
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => setState(() {
                    initState();
                  }),
                  child: ErrorCard(
                    errorMessage: _warningMessage,
                  ),
                ),
              );
            } else if (snapshot.hasData &&
                snapshot.data.snapshot.value != null) {
              final roomsList = roomsProcessor(snapshot);
              return RoomCardsCarousel(roomsList: roomsList);
            } else {
              return ErrorCard(
                errorMessage: 'There are no rooms configured in the database.',
              );
            }
        }
      }),
    );
  }
}
class RoomCardsCarousel extends StatefulWidget {
  final List<Room> roomsList;
  RoomCardsCarousel({Key? key, required this.roomsList}) : super(key: key);
  @override
  _RoomCardsCarouselState createState() => _RoomCardsCarouselState();
}
class _RoomCardsCarouselState extends State<RoomCardsCarousel> {
  int _index = 0;
  int labelIndex = 0;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.70),
      onPageChanged: (int index) =>
          setState(() => _index = index % widget.roomsList.length),
      scrollDirection: Axis.horizontal,
      itemCount: widget.roomsList.length,
      itemBuilder: (_, index) {
        return Transform.scale(
            scale: index == _index ? 1 : 0.8,
            child: RoomCard(name: widget.roomsList[index].name));
      },
    );
  }
}
class RoomCard extends StatelessWidget {
  RoomCard({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;
  final borderShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  Widget build(BuildContext context) {
    String image = setRoomImage(name);
    return Card(
      shadowColor: Colors.blue,
      shape: borderShape,
      child: InkWell(
        splashColor: lightBlue,
        focusColor: lightBlue,
        customBorder: borderShape,
        onTap: () {
          context.read<ChosenDeviceType>().setChosenRoom(name);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(name: name),
              ));
        },
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                name.toUpperCase(),
                minFontSize: 25,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
    }
}
