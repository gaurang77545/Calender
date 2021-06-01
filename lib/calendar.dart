import 'package:calendar/GoogleCalender/Home.dart';
import 'package:calendar/event.dart';
import 'package:calendar/provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  ScrollController scrollController;
  bool dialVisible = true;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    super.initState();
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  Widget buildBody() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 30,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item $i')),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      /// This is ignored if animatedIcon is non null
      icon: Icons.add,
      activeIcon: Icons.remove,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Defaults to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
      buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white70,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      gradientBoxShape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue, Colors.white],
      ),
      children: [
        SpeedDialChild(
            child: Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            label: 'Add Event',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.grey),
            // onTap: () => print('FIRST CHILD'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add Event"),
                  content: TextFormField(
                    controller: _eventController,
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        if (_eventController.text.isEmpty) {
                        } else {
                          // if (selectedEvents[selectedDay] != null) {
                          if (!Provider.of<EventsHandler>(context,
                                  listen: false)
                              .check(selectedDay)) {
                            Provider.of<EventsHandler>(context, listen: false)
                                .add(selectedDay, _eventController.text);
                            //selectedEvents[selectedDay].add(
                            //Event(title: _eventController.text),
                            //);
                          } else {
                            //Adding for the first Time
                            Provider.of<EventsHandler>(context, listen: false)
                                .init(selectedDay, _eventController.text);
                            // selectedEvents[selectedDay] = [
                            //   Event(title: _eventController.text)
                            // ];
                          }
                        }
                        Navigator.pop(context);
                        _eventController.clear();
                        setState(() {});
                        return;
                      },
                    ),
                  ],
                ),
              );
            }),
        SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.blue,
            label: 'Google Calender',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.red),
            onTap: () {
              Navigator.of(context).pushNamed(Home.routeName);
            }
            // onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
      ],
    );
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: selectedDay, //Where the boundary comes on
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format, //In what format we want the calender
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek
                  .sunday, //Whether in calender on top we want the day to be Sunday or something else as the first day
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                //If we are selecting something then we are changing the selected day and the focussed day
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsfromDay,

              //To style the Calendar
              calendarStyle: CalendarStyle(
                holidayDecoration: BoxDecoration(color: Colors.grey),
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible:
                    true, //format button is the button which tells what format u want the calender to be displayed
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // ..._getEventsfromDay(selectedDay).map(
            //   (Event event) => ListTile(
            //     title: Text(
            //       event.title,
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
            ...Provider.of<EventsHandler>(context)
                .getEventsfromDay(selectedDay)
                .map(
                  (Event event) => Container(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        event.title,
                        style: TextStyle(color: HexColor('#BB86FC')),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      tileColor: HexColor('#050121'),
                      
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
      floatingActionButton: buildSpeedDial(),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Add Event"),
      //       content: TextFormField(
      //         controller: _eventController,
      //       ),
      //       actions: [
      //         TextButton(
      //           child: Text("Cancel"),
      //           onPressed: () => Navigator.pop(context),
      //         ),
      //         TextButton(
      //           child: Text("Ok"),
      //           onPressed: () {
      //             if (_eventController.text.isEmpty) {
      //             } else {
      //              // if (selectedEvents[selectedDay] != null) {
      //                if(! Provider.of<EventsHandler>(context,listen: false).check(selectedDay))
      //                {
      //                 Provider.of<EventsHandler>(context,listen: false)
      //                     .add(selectedDay, _eventController.text);
      //                 //selectedEvents[selectedDay].add(
      //                 //Event(title: _eventController.text),
      //                 //);
      //               } else {
      //                 //Adding for the first Time
      //                  Provider.of<EventsHandler>(context,listen: false).init(selectedDay, _eventController.text);
      //                 // selectedEvents[selectedDay] = [
      //                 //   Event(title: _eventController.text)
      //                 // ];
      //               }
      //             }
      //             Navigator.pop(context);
      //             _eventController.clear();
      //             setState(() {});
      //             return;
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      //   label: Text("Add Event"),
      //   icon: Icon(Icons.add),
      // ),
    );
  }
}
