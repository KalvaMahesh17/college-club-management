// lib/screens/events_screen.dart
// Events listing screen

import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  final EventService _eventService = EventService();
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  String _searchQuery = '';
  List<String> _registeredEvents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRegistered();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadRegistered() {
    setState(() {
      _registeredEvents = StorageService.getRegisteredEvents();
    });
  }

  List<Event> get _allEvents {
    if (_searchQuery.isNotEmpty) {
      return _eventService.searchEvents(_searchQuery);
    }
    return _eventService.getAllEvents();
  }

  List<Event> get _upcomingEvents {
    if (_searchQuery.isNotEmpty) {
      return _eventService.searchEvents(_searchQuery);
    }
    return _eventService.getUpcomingEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppTheme.textHint),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
          ),
        ),
        // Tabs
        Container(
          color: AppTheme.surface,
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'Upcoming (${_upcomingEvents.length})'),
              Tab(text: 'All Events (${_allEvents.length})'),
            ],
          ),
        ),
        // Event lists
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEventList(_upcomingEvents, 'No upcoming events.'),
              _buildEventList(_allEvents, 'No events found.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(List<Event> events, String emptyMessage) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy_outlined,
                  size: 64, color: AppTheme.textHint),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No events found for "$_searchQuery"'
                    : emptyMessage,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: const Text('Clear Search'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isRegistered = _registeredEvents.contains(event.id);
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
                .then((_) => _loadRegistered());
          },
        );
      },
    );
  }
}
