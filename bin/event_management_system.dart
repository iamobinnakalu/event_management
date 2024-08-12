import 'dart:io';

void main() {
  
}

class Event{

//initialization of the variables
String title;
DateTime dateTime;
String location;
String description;

//Here is  an Event class constructor
Event({
  required this.title,
  required this.dateTime,
  required this.location,
  required this.description
  });

  @override
  String toString() {
    return'Event: $title at $location on $dateTime with $description'; 
  }
}

class EventManagement{

  //This is the Event Management System variables
  String name;
  bool isPresent;

  //Here is the Event Management Constructor
  EventManagement(this.name, this.isPresent);

  @override
  String toString(){
    return'EventManagement: $name is Present $isPresent';
  }
}
