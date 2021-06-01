import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:calendar/event.dart';

class EventsHandler with ChangeNotifier {
  Map<DateTime, List<Event>> selectedEvents = {};
  List<Event> getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  bool  check(DateTime date) {
    return selectedEvents[date]==null;
  }

  void add(DateTime selectedDay, String text) {
    selectedEvents[selectedDay].add(
      Event(title: text),
    );
    print(selectedEvents.toString());
    notifyListeners();
  }

  void init(DateTime selectedDay, String text) {
    selectedEvents[selectedDay] = [Event(title: text)];
    print(selectedEvents.toString() + "AAAAAAAA");
    notifyListeners();
  }
}
