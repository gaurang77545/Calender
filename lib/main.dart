import 'package:calendar/GoogleCalender/Home.dart';
import 'package:calendar/calendar.dart';
import 'package:calendar/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => EventsHandler())
      ],
      child:
         MaterialApp(
           debugShowCheckedModeBanner: false,
        title: "ESTech Calendar",
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: Calendar(),
        routes: {
          Home.routeName:(ctx) => Home()
        },
      ),
    );
  }
}
