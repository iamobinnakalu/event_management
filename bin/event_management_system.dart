

import 'dart:io';
import 'dart:convert';
import 'package:collection/collection.dart';

class Event {
  // Initialization of the Event class variables
  String title;
  DateTime dateTime;
  String location;
  String description;
  List<Attendee> attendees;

  // Event class constructor
  Event({
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.attendees,
  });

  @override
  String toString() {
    return 'Event: $title at $location on $dateTime with $description';
  }

  // Convert Event object to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'location': location,
        'description': description,
        'attendees': attendees.map((a) => a.toJson()).toList(),
      };

  // Convert JSON to Event object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']), // Correct field name
      location: json['location'],
      description: json['description'],
      attendees:
          (json['attendees'] as List).map((a) => Attendee.fromJson(a)).toList(),
    );
  }
}

class Attendee {
  // Initialization of the Attendee class variables
  String name;
  bool isPresent;

  // Attendee class constructor
  Attendee(this.name, {this.isPresent = true});

  @override
  String toString() {
    return 'Attendee: $name is Present: $isPresent';
  }

  // Convert Attendee object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'isPresent': isPresent,
      };

  // Convert JSON to Attendee object
  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      json['name'],
      isPresent: json['isPresent'] ?? true,
    );
  }
}

// Saving events to a JSON file
void saveEvents(List<Event> events) {
  File file = File('events.json');
  List<Map<String, dynamic>> jsonEvents =
      events.map((e) => e.toJson()).toList();
  file.writeAsStringSync(jsonEncode(jsonEvents));
}

// Loading events from a JSON file
List<Event> loadEvents() {
  File file = File('events.json');
  if (file.existsSync()) {
    String content = file.readAsStringSync();
    List<dynamic> jsonList = jsonDecode(content);
    return jsonList.map((e) => Event.fromJson(e)).toList();
  }
  return [];
}

void addNewEvent(List<Event> events) {
  print("Enter Event Title:");
  String title = stdin.readLineSync()!;

  print('Enter event date and time (YYYY-MM-DD HH:MM):');
  DateTime dateTime = DateTime.parse(stdin.readLineSync()!);

  print('Enter event location:');
  String location = stdin.readLineSync()!;

  print('Enter event description:');
  String description = stdin.readLineSync()!;

  events.add(Event(
    title: title,
    dateTime: dateTime,
    location: location,
    description: description,
    attendees: [],
  ));

  print('Event Added Successfully!\n');
}

void editEvent(List<Event> events) {
  print('Enter the title of the event to edit:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhereOrNull((event) => event.title == title);

  if (event != null) {
    print('Enter new title:');
    event.title = stdin.readLineSync()!;

    print('Enter new date and time (YYYY-MM-DD HH:MM):');
    event.dateTime = DateTime.parse(stdin.readLineSync()!);

    print('Enter new location:');
    event.location = stdin.readLineSync()!;

    print('Enter new description:');
    event.description = stdin.readLineSync()!;

    print('Event updated successfully!\n');
  } else {
    print('Event not found!\n');
  }
}

void deleteEvent(List<Event> events) {
  print('Enter the title of the event to delete:');
  String title = stdin.readLineSync()!;
  events.removeWhere((event) => event.title == title);
  print('Event deleted successfully!\n');
}

void listEvents(List<Event> events) {
  if (events.isEmpty) {
    print('No events found.\n');
  } else {
    for (var event in events) {
      print(event);
    }
    print('');
  }
}

void registerAttendee(List<Event> events) {
  print('Enter the title of the event:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhereOrNull((event) => event.title == title);

  if (event != null) {
    print('Enter the name of the attendee:');
    String name = stdin.readLineSync()!;
    event.attendees.add(Attendee(name));
    print('Attendee registered successfully!\n');
  } else {
    print('Event not found!\n');
  }
}

void viewAttendees(List<Event> events) {
  print('Enter the title of the event:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhereOrNull((event) => event.title == title);

  if (event != null) {
    if (event.attendees.isEmpty) {
      print('No attendees registered.\n');
    } else {
      for (var attendee in event.attendees) {
        print(attendee);
      }
      print('');
    }
  } else {
    print('Event not found!\n');
  }
}

void markAttendance(List<Event> events) {
  print('Enter the title of the event:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhereOrNull((event) => event.title == title);

  if (event != null) {
    print('Enter the name of the attendee:');
    String name = stdin.readLineSync()!;
    Attendee? attendee =
        event.attendees.firstWhereOrNull((attendee) => attendee.name == name);

    if (attendee != null) {
      attendee.isPresent = true;
      print('Attendance marked successfully!\n');
    } else {
      print('Attendee not found!\n');
    }
  } else {
    print('Event not found!\n');
  }
}

void main() {
  List<Event> events = loadEvents();

  while (true) {
    print('Rad5 Tech Hub Event Manager System');
    print('1. Add New Event');
    print('2. Edit Event');
    print('3. Delete Event');
    print('4. List All Events');
    print('5. Register Attendee');
    print('6. View Attendees');
    print('7. Mark Attendance');
    print('8. Save and Exit');
    print('Enter your choice:');

    String? choice = stdin.readLineSync();

    if (choice == '1') {
      addNewEvent(events);
    } else if (choice == '2') {
      editEvent(events);
    } else if (choice == '3') {
      deleteEvent(events);
    } else if (choice == '4') {
      listEvents(events);
    } else if (choice == '5') {
      registerAttendee(events);
    } else if (choice == '6') {
      viewAttendees(events);
    } else if (choice == '7') {
      markAttendance(events);
    } else if (choice == '8') {
      saveEvents(events);
      print('Saving...');
      print('Exiting...');
      return;
    } else {
      print('Invalid choice, please try again.');
    }
  }
}
