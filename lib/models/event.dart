// lib/models/event.dart
// Event data model

class Event {
  final String id;
  final String title;
  final String clubId;
  final String clubName;
  final String date;
  final String time;
  final String location;
  final String description;
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.clubId,
    required this.clubName,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.category,
  });

  /// Create Event from a Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      clubId: map['clubId'] as String,
      clubName: map['clubName'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
    );
  }

  /// Convert Event to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'clubId': clubId,
      'clubName': clubName,
      'date': date,
      'time': time,
      'location': location,
      'description': description,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Event{id: $id, title: $title, clubName: $clubName}';
  }
}
