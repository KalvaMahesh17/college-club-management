// lib/services/club_service.dart
// Club data service - provides all club data

import '../models/club.dart';

class ClubService {
  // Singleton instance
  static final ClubService _instance = ClubService._internal();
  factory ClubService() => _instance;
  ClubService._internal();

  /// Master list of all 5 college clubs
  final List<Club> _clubs = [
    Club(
      id: 'club_001',
      name: 'Coding Club',
      category: 'Technical',
      description:
          'The Coding Club is dedicated to building strong problem-solving skills, competitive programming, software development, hackathons, and placement preparation for technical interviews.',
      coordinator: 'Dr. Anita Singh (Dept of IT)',
      meetingDay: 'Every Tuesday & Thursday',
      meetingTime: '4:30 PM',
      location: 'Advanced IT Lab, Block B',
      memberCount: 95,
      iconEmoji: '💻',
    ),
    Club(
      id: 'club_002',
      name: 'Cultural Club',
      category: 'Cultural',
      description:
          'The Cultural Club celebrates artistic talent, stage presence, drama, classical performances, and organizes the prestigious annual inter-collegiate college cultural fest.',
      coordinator: 'Prof. Meera Nair',
      meetingDay: 'Every Wednesday',
      meetingTime: '4:00 PM',
      location: 'Main Campus Auditorium',
      memberCount: 74,
      iconEmoji: '🎭',
    ),
    Club(
      id: 'club_003',
      name: 'Sports Club',
      category: 'Sports',
      description:
          'The Sports Club promotes fitness, teamwork, and athletic excellence across cricket, football, basketball, badminton, and track events with regular training and tournaments.',
      coordinator: 'Mr. Suresh Patel',
      meetingDay: 'Mon, Wed, Fri',
      meetingTime: '6:30 AM',
      location: 'College Sports Ground & Arena',
      memberCount: 120,
      iconEmoji: '⚽',
    ),
    Club(
      id: 'club_004',
      name: 'Photography Club',
      category: 'Photography',
      description:
          'The Photography Club captures unforgettable campus memories, teaches visual composition, DSLR camera handling, digital editing, photowalks, and annual photo exhibitions.',
      coordinator: 'Prof. K. Venkatesh',
      meetingDay: 'Every Saturday',
      meetingTime: '10:00 AM',
      location: 'Media Studio & Campus Grounds',
      memberCount: 48,
      iconEmoji: '📸',
    ),
    Club(
      id: 'club_005',
      name: 'Music Club',
      category: 'Music',
      description:
          'The Music Club is the rhythm of campus life, featuring instrumentalists, vocalists, acoustic jam sessions, open mics, and band performances at major college functions.',
      coordinator: 'Mr. Rajiv Sharma',
      meetingDay: 'Every Friday',
      meetingTime: '5:00 PM',
      location: 'Music & Arts Hall, Ground Floor',
      memberCount: 52,
      iconEmoji: '🎵',
    ),
  ];

  /// Get all clubs
  List<Club> getAllClubs() => List.unmodifiable(_clubs);

  /// Get club by ID
  Club? getClubById(String id) {
    try {
      return _clubs.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Search clubs by name or category
  List<Club> searchClubs(String query) {
    if (query.trim().isEmpty) return getAllClubs();
    final lower = query.toLowerCase();
    return _clubs.where((c) {
      return c.name.toLowerCase().contains(lower) ||
          c.category.toLowerCase().contains(lower) ||
          c.coordinator.toLowerCase().contains(lower);
    }).toList();
  }

  /// Filter clubs by category
  List<Club> filterByCategory(String category) {
    if (category == 'All') return getAllClubs();
    return _clubs.where((c) => c.category == category).toList();
  }

  /// Get clubs by IDs (for My Clubs screen)
  List<Club> getClubsByIds(List<String> ids) {
    return _clubs.where((c) => ids.contains(c.id)).toList();
  }

  /// Total club count
  int get totalClubs => _clubs.length;

  /// Total member count (sum of all clubs)
  int get totalMembers => _clubs.fold(0, (sum, c) => sum + c.memberCount);

  /// Increment member count when user joins
  void incrementMemberCount(String clubId) {
    final club = _clubs.firstWhere((c) => c.id == clubId, orElse: () => throw Exception('Club not found'));
    club.memberCount++;
  }

  /// Decrement member count when user leaves
  void decrementMemberCount(String clubId) {
    final club = _clubs.firstWhere((c) => c.id == clubId, orElse: () => throw Exception('Club not found'));
    if (club.memberCount > 0) club.memberCount--;
  }
}
