// lib/services/event_service.dart
// Event data service - provides all event data

import '../models/event.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final List<Event> _events = [
    Event(
      id: 'evt_001',
      title: 'National Hackathon 2026',
      clubId: 'club_001',
      clubName: 'Coding Club',
      date: '2026-10-15',
      time: '9:00 AM',
      location: 'Advanced IT Lab, Block B',
      description:
          'A 24-hour hackathon where student teams build innovative software solutions for real-world campus and industry challenges. Prizes worth ₹50,000! Free food and swag kit included.',
      category: 'Technical',
    ),
    Event(
      id: 'evt_002',
      title: 'Annual Cultural Fest — Tarang 2026',
      clubId: 'club_002',
      clubName: 'Cultural Club',
      date: '2026-10-22',
      time: '5:00 PM',
      location: 'Main Campus Auditorium',
      description:
          'The flagship cultural event of the year featuring music, dance performances, drama, fashion show, and talent competitions from colleges across the region.',
      category: 'Cultural',
    ),
    Event(
      id: 'evt_003',
      title: 'Inter-Department Football Championship',
      clubId: 'club_003',
      clubName: 'Sports Club',
      date: '2026-11-01',
      time: '7:00 AM',
      location: 'College Sports Arena',
      description:
          'Inter-branch knockout football tournament. Support your department and witness exciting, competitive action on the field!',
      category: 'Sports',
    ),
    Event(
      id: 'evt_004',
      title: 'Campus PhotoWalk & Visual Storytelling',
      clubId: 'club_004',
      clubName: 'Photography Club',
      date: '2026-10-18',
      time: '8:30 AM',
      location: 'Campus Amphitheatre & Quad',
      description:
          'Hands-on photography walk exploring framing, composition, natural lighting, and street photography. Bring your smartphone or DSLR.',
      category: 'Photography',
    ),
    Event(
      id: 'evt_005',
      title: 'Acoustic Jam & Open Mic Night',
      clubId: 'club_005',
      clubName: 'Music Club',
      date: '2026-10-25',
      time: '6:00 PM',
      location: 'Outdoor Amphitheatre',
      description:
          'An unplugged musical evening under the stars. Any student can perform — solo or group. Guitar, keyboards, vocals, and classical instruments welcome!',
      category: 'Music',
    ),
    Event(
      id: 'evt_006',
      title: 'Flutter & Dart Mobile App Workshop',
      clubId: 'club_001',
      clubName: 'Coding Club',
      date: '2026-11-05',
      time: '10:00 AM',
      location: 'IT Seminar Hall, Block B',
      description:
          'Hands-on Flutter development session for IT and engineering students. Learn widgets, state management, and build a complete mobile app in 3 hours.',
      category: 'Technical',
    ),
    Event(
      id: 'evt_007',
      title: 'Annual Inter-College Cricket League',
      clubId: 'club_003',
      clubName: 'Sports Club',
      date: '2026-11-10',
      time: '8:00 AM',
      location: 'Main College Cricket Ground',
      description:
          'T20 cricket championship with 12 college teams competing for the annual trophy. Live commentary, refreshments, and athletic energy guaranteed.',
      category: 'Sports',
    ),
    Event(
      id: 'evt_008',
      title: 'Monochrome Photo Contest & Gallery',
      clubId: 'club_004',
      clubName: 'Photography Club',
      date: '2026-11-15',
      time: '2:00 PM',
      location: 'Central Library Foyer',
      description:
          'Black-and-white theme photography competition. Top 20 student submissions will be printed, framed, and displayed in the college exhibition gallery.',
      category: 'Photography',
    ),
  ];

  /// Get all events
  List<Event> getAllEvents() => List.unmodifiable(_events);

  /// Get event by ID
  Event? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get events for a specific club
  List<Event> getEventsByClub(String clubId) {
    return _events.where((e) => e.clubId == clubId).toList();
  }

  /// Get upcoming events (by string comparison — suitable for this lab project)
  List<Event> getUpcomingEvents() {
    final today = DateTime.now();
    return _events.where((e) {
      try {
        final parts = e.date.split('-');
        final eventDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        return eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today);
      } catch (_) {
        return true;
      }
    }).toList();
  }

  /// Search events by title or club name
  List<Event> searchEvents(String query) {
    if (query.trim().isEmpty) return getAllEvents();
    final lower = query.toLowerCase();
    return _events.where((e) {
      return e.title.toLowerCase().contains(lower) ||
          e.clubName.toLowerCase().contains(lower) ||
          e.category.toLowerCase().contains(lower) ||
          e.location.toLowerCase().contains(lower);
    }).toList();
  }

  /// Get events by IDs
  List<Event> getEventsByIds(List<String> ids) {
    return _events.where((e) => ids.contains(e.id)).toList();
  }

  /// Total event count
  int get totalEvents => _events.length;

  /// Upcoming event count
  int get upcomingEventCount => getUpcomingEvents().length;

  /// Format date string for display
  static String formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      const days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${days[date.weekday]}, ${date.day} ${months[date.month]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
