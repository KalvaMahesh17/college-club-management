// lib/models/user.dart
// User data model

class AppUser {
  final String email;
  final String name;
  final String rollNo;
  final String department;
  final String year;

  AppUser({
    required this.email,
    required this.name,
    required this.rollNo,
    this.department = 'IT (Information Technology)',
    this.year = 'B.Tech – 3rd Year',
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] as String,
      name: map['name'] as String,
      rollNo: map['rollNo'] as String? ?? '',
      department: map['department'] as String? ?? 'IT',
      year: map['year'] as String? ?? 'B.Tech – 3rd Year',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'rollNo': rollNo,
      'department': department,
      'year': year,
    };
  }

  @override
  String toString() {
    return 'AppUser{name: $name, rollNo: $rollNo, dept: $department}';
  }
}
