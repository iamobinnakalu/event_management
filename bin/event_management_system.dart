
import 'dart:io';
import 'dart:convert';


class Event{

//initialization of the Event class variables
String title;
DateTime dateTime;
String location;
String description;
List<Attendee> attendees;

//Here is  an Event class constructor
Event({
  required this.title,
  required this.dateTime,
  required this.location,
  required this.description,
  required this.attendees,
  });

  @override
  String toString() {
    return'Event: $title at $location on $dateTime with $description'; 
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'dateTime': dateTime.toIso8601String(),
    'location': location,
    'description': description,
    'attendees': attendees.map((a) => a.toJson()).toList(),
  };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
     title: json['title'],
     dateTime: DateTime.parse(json['datetime']), 
     location: json['location'], 
     description: json['description'], 
     attendees: (json['attendees'] as List).map((a) => Attendee.fromJson(a)).toList(),
     );
  }
}

class Attendee{

  //Initialization of the Event Management class variables
  String name;
  bool isPresent;

  //Here is the Event Management Constructor
  Attendee(this.name, {this.isPresent = false});

  @override
  String toString(){
    return'Attendee: $name is Present $isPresent';
  }

  Map<String, dynamic> toJson() => {
  'name': name,
  'isPresent': isPresent,
  };

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
     json['name'], 
     isPresent: json['isPresent'] ?? false,
     );
  }
}



//Saving The Program To A JSON File Format
void saveEvents(List<Event> events) {
  File file = File('events.json');
  List<Map<String, dynamic>> jsonEvents = events.map((e) => e.toJson()).toList();
  file.writeAsStringSync(jsonEncode(jsonEvents));
}

//Loading The Program From A JSON File
List<Event> loadEvents() {
  File file = File('events.json');
  if (file.existsSync()) {
    String content = file.readAsStringSync();
    List<dynamic> jsonList = jsonDecode(content);
    return jsonList.map((e) => Event.fromJson(e)).toList();
  }
  return[];
}


void addNewEvent(List<Event> events) {

  print("Enter Event Title");
  String title = stdin.readLineSync()!;
  
  print('Enter event date and time (YYYY-MM-DD  HH:MM):');
  DateTime dateTime = DateTime.parse(stdin.readLineSync()!);
  
  print('Enter event location');
  String location = stdin.readLineSync()!;
  
  print('Enter event description');
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
  print('Enter The Title Of The Event To Edit:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhere(
    (event) => event.title == title,
    //orElse: () => null,
  );

  if (event != null) {
    print('Enter New Title:');
    event.title = stdin.readLineSync()!;

    print('Enter New Date And Time (YYYY-MM-DD HH:MM):');
    event.dateTime = DateTime.parse(stdin.readLineSync()!);

    print('Enter New Location:');
    event.location = stdin.readLineSync()!;

    print('Enter New Description:');
    event.description = stdin.readLineSync()!;

    print('Event Update Successfully!\n');
  } else {
    print('Event Not Found!\n');
  }
}


void deleteEvent(List<Event> events) {
  print('Enter The Title Of The Event To Delete:');
  String title = stdin.readLineSync()!;
  events.removeWhere((event) => event.title == title);
  print('Event Delete Successfully!\n');
}

void listEvents(List<Event> events) {
  if (events.isEmpty) {
    print('No Events Found.\n');
  } else {
    for (var event in events) {
      print(event);
    }
    print('');
  }
}

void registerAttendee(List<Event> events) {
  print('Enter The Title Of The Event:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhere(
    (event) => event.title == title,
      //orElse: () => null,
  );
 
  if (event != null) {
    print('Enter The Name OF The Attendee:');
    String name = stdin.readLineSync()!;
    event.attendees.add(Attendee(name));
    print('Attendee Registered Successfully!\n');
  } else {
    print('Event Not Found!\n');
  }
}


void viewAttendees(List<Event> events) {
  print('Enter The Title Of The Event:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhere(
    (event) => event.title == title,
   // orElse: () => null,
  );

  if (event != null) {
    if (event.attendees.isEmpty) {
      print('No Attendees Registered.\n');
    } else {
      for (var attendee in event.attendees) {
        print(attendee);
      }
      print('');
      }
  } else {
    print('Event Not Found!\n');
  }
}


void markAttendance(List<Event> events) {
  print('Enter The Title Of The Event:');
  String title = stdin.readLineSync()!;
  Event? event = events.firstWhere(
    (event) => event.title == title,
    //orElse: () => null,
  );

  if (event != null) {
    print('Enter The Name Of The Attendee:');
    String name = stdin.readLineSync()!;
    Attendee? attendee = event.attendees.firstWhere(
      (attendee) => attendee.name == name,
     // orElse: () => null,
    );

    if (attendee != null) {
      attendee.isPresent = true;
      print('Attendance marked successfully!\n');
    } else {
      print('Attendee Not Found!\n');
    }
  } else {
    print('Event Not Found!\n');
  }
}
  


void main() {
  List<Event> events = [];
  

  while (true) {
    print('Tech Hub Event Manager');
    print('1. Add New Event');
    print('2. Edit Event');
    print('3. Delete Event');
    print('4. List All Events');
    print('5. Register Attendee');
    print('6. View Attendees');
    print('7. Mark Attendance');
    print('8. Exit');
    print('Enter Your Choice:');


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
      viewAttendees(events) ;
    } else if (choice == '7') {
      markAttendance(events);
    } else if (choice == '8') {
      print('Goodbye!');
      return;
    } else {
      print('Invalid Choice, Please Try Again.');
    }
  }
} 

