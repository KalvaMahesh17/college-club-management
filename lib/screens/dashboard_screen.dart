// lib/screens/dashboard_screen.dart
// Main dashboard with live statistics

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../services/club_service.dart';
import '../services/event_service.dart';
import '../services/storage_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/event_card.dart';
import 'clubs_screen.dart';
import 'events_screen.dart';
import 'event_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int)? onSwitchTab;
  const DashboardScreen({super.key, this.onSwitchTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ClubService _clubService = ClubService();
  final EventService _eventService = EventService();

  String _userName = '';
  List<String> _joinedClubs = [];
  List<String> _registeredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _userName = StorageService.getUserName();
      _joinedClubs = StorageService.getJoinedClubs();
      _registeredEvents = StorageService.getRegisteredEvents();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _firstName => _userName.split(' ').first;

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = _eventService.getUpcomingEvents().take(3).toList();

    return RefreshIndicator(
      onRefresh: () async => _loadData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Greeting header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_greeting,',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _firstName.isNotEmpty ? _firstName : 'Student',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${StorageService.getUserRollNo().isNotEmpty ? StorageService.getUserRollNo() : AppConstants.demoRollNo} • ${StorageService.getUserDepartment()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('🎓', style: TextStyle(fontSize: 28)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Statistics heading
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // Stats grid - 2 columns
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  title: 'Total Clubs',
                  value: '${_clubService.totalClubs}',
                  icon: Icons.groups_outlined,
                  color: AppTheme.primary,
                  onTap: () => _goToTab(context, AppConstants.navClubs),
                ),
                StatCard(
                  title: 'My Clubs',
                  value: '${_joinedClubs.length}',
                  icon: Icons.star_outline,
                  color: AppTheme.warning,
                  onTap: () => _goToTab(context, AppConstants.navMyClubs),
                ),
                StatCard(
                  title: 'Total Events',
                  value: '${_eventService.totalEvents}',
                  icon: Icons.event_outlined,
                  color: AppTheme.accent,
                  onTap: () => _goToTab(context, AppConstants.navEvents),
                ),
                StatCard(
                  title: 'Registered',
                  value: '${_registeredEvents.length}',
                  icon: Icons.how_to_reg_outlined,
                  color: AppTheme.success,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Upcoming events section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => _goToTab(context, AppConstants.navEvents),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (upcomingEvents.isEmpty)
              _emptyState(
                  Icons.event_busy_outlined, 'No upcoming events right now.')
            else
              ...upcomingEvents.map((event) {
                final isRegistered =
                    _registeredEvents.contains(event.id);
                return EventCard(
                  event: event,
                  isRegistered: isRegistered,
                  onView: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(eventId: event.id),
                      ),
                    )
                        .then((_) => _loadData());
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  void _goToTab(BuildContext context, int tabIndex) {
    if (widget.onSwitchTab != null) {
      widget.onSwitchTab!(tabIndex);
      return;
    }
    Widget screen;
    if (tabIndex == AppConstants.navClubs) {
      screen = const ClubsScreen();
    } else if (tabIndex == AppConstants.navEvents) {
      screen = const EventsScreen();
    } else {
      screen = const MyClubsScreen();
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _loadData());
  }

  Widget _emptyState(IconData icon, String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppTheme.textHint),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
