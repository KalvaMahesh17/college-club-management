// lib/screens/club_details_screen.dart
// Detailed club view with membership action and related events

import 'package:flutter/material.dart';
import '../models/club.dart';
import '../models/event.dart';
import '../services/club_service.dart';
import '../services/event_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import 'event_details_screen.dart';

class ClubDetailsScreen extends StatefulWidget {
  final String clubId;

  const ClubDetailsScreen({super.key, required this.clubId});

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen> {
  final ClubService _clubService = ClubService();
  final EventService _eventService = EventService();

  Club? _club;
  List<Event> _clubEvents = [];
  bool _isJoined = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final club = _clubService.getClubById(widget.clubId);
    setState(() {
      _club = club;
      _clubEvents = _eventService.getEventsByClub(widget.clubId);
      _isJoined = StorageService.hasJoinedClub(widget.clubId);
    });
  }

  Future<void> _toggleMembership() async {
    if (_isJoined) {
      // Already joined — show info
      _showSnack('You are already a member of ${_club!.name}!', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    await StorageService.joinClub(widget.clubId);
    _clubService.incrementMemberCount(widget.clubId);

    setState(() {
      _isJoined = true;
      _isLoading = false;
    });

    _showSnack('You have joined ${_club!.name}! 🎉');
  }

  Future<void> _leaveClub() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Leave Club'),
        content: Text('Are you sure you want to leave ${_club!.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));

    await StorageService.leaveClub(widget.clubId);
    _clubService.decrementMemberCount(widget.clubId);

    setState(() {
      _isJoined = false;
      _isLoading = false;
    });

    _showSnack('You have left ${_club!.name}.');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.error : AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_club == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Club Details')),
        body: const Center(child: Text('Club not found.')),
      );
    }

    final club = _club!;
    final categoryColor = AppTheme.getCategoryColor(club.category);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Gradient app bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: categoryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor,
                      categoryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      club.iconEmoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      club.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & members row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          club.category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.people, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${club.memberCount} Members',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  _sectionTitle('About the Club'),
                  const SizedBox(height: 8),
                  Text(
                    club.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Club info cards
                  _sectionTitle('Club Information'),
                  const SizedBox(height: 10),
                  _infoCard([
                    _infoRow(Icons.person_outline, 'Coordinator', club.coordinator),
                    const Divider(height: 20),
                    _infoRow(Icons.calendar_month_outlined, 'Meeting Day', club.meetingDay),
                    const Divider(height: 20),
                    _infoRow(Icons.access_time, 'Meeting Time', club.meetingTime),
                    const Divider(height: 20),
                    _infoRow(Icons.location_on_outlined, 'Location', club.location),
                  ]),
                  const SizedBox(height: 24),
                  // Membership button
                  SizedBox(
                    width: double.infinity,
                    child: _isJoined
                        ? Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.successLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: AppTheme.success.withOpacity(0.3)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: AppTheme.success, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'JOINED — You are a member',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: _isLoading ? null : _leaveClub,
                                icon: const Icon(Icons.exit_to_app,
                                    size: 16, color: AppTheme.error),
                                label: const Text(
                                  'Leave Club',
                                  style: TextStyle(
                                    color: AppTheme.error,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ElevatedButton.icon(
                            onPressed: _isLoading ? null : _toggleMembership,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.add),
                            label: const Text('Join This Club'),
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                  ),
                  const SizedBox(height: 28),
                  // Related events
                  _sectionTitle('Club Events (${_clubEvents.length})'),
                  const SizedBox(height: 10),
                  if (_clubEvents.isEmpty)
                    _emptyState('No events scheduled yet.')
                  else
                    ..._clubEvents.map((event) {
                      final isRegistered =
                          StorageService.hasRegisteredEvent(event.id);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailsScreen(eventId: event.id),
                            ),
                          )
                              .then((_) => setState(() {}));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.event,
                                    color: categoryColor, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${event.date} • ${event.time}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isRegistered)
                                const Icon(Icons.check_circle,
                                    color: AppTheme.success, size: 18),
                              const Icon(Icons.chevron_right,
                                  color: AppTheme.textHint, size: 18),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
