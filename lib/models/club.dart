// lib/models/club.dart
// Club data model

class Club {
  final String id;
  final String name;
  final String category;
  final String description;
  final String coordinator;
  final String meetingDay;
  final String meetingTime;
  final String location;
  int memberCount;
  final String iconEmoji;

  Club({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.coordinator,
    required this.meetingDay,
    required this.meetingTime,
    required this.location,
    required this.memberCount,
    required this.iconEmoji,
  });

  /// Create Club from a Map (for future JSON/storage support)
  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      coordinator: map['coordinator'] as String,
      meetingDay: map['meetingDay'] as String,
      meetingTime: map['meetingTime'] as String,
      location: map['location'] as String,
      memberCount: map['memberCount'] as int,
      iconEmoji: map['iconEmoji'] as String,
    );
  }

  /// Convert Club to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'coordinator': coordinator,
      'meetingDay': meetingDay,
      'meetingTime': meetingTime,
      'location': location,
      'memberCount': memberCount,
      'iconEmoji': iconEmoji,
    };
  }

  @override
  String toString() {
    return 'Club{id: $id, name: $name, category: $category}';
  }
}
