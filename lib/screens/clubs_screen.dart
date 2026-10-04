// lib/screens/clubs_screen.dart
// Club listing screen with search and category filter

import 'package:flutter/material.dart';
import '../models/club.dart';
import '../services/club_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/club_card.dart';
import 'club_details_screen.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  final ClubService _clubService = ClubService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<String> _joinedClubs = [];

  @override
  void initState() {
    super.initState();
    _loadJoined();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadJoined() {
    setState(() {
      _joinedClubs = StorageService.getJoinedClubs();
    });
  }

  List<Club> get _filteredClubs {
    List<Club> clubs;
    if (_searchQuery.isNotEmpty) {
      clubs = _clubService.searchClubs(_searchQuery);
    } else {
      clubs = _clubService.filterByCategory(_selectedCategory);
    }
    return clubs;
  }

  Future<void> _joinClub(Club club) async {
    if (_joinedClubs.contains(club.id)) {
      _showSnack('You have already joined ${club.name}!',
          isError: true);
      return;
    }
    await StorageService.joinClub(club.id);
    _clubService.incrementMemberCount(club.id);
    _loadJoined();
    _showSnack('Successfully joined ${club.name}! 🎉');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.error : AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clubs = _filteredClubs;

    return Column(
      children: [
        // Search & filter header
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search clubs...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.textHint),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: AppTheme.textHint),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              // Category filter chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.clubCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = AppConstants.clubCategories[index];
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.border,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Club list
        Expanded(
          child: clubs.isEmpty
              ? _emptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: clubs.length,
                  itemBuilder: (context, index) {
                    final club = clubs[index];
                    return ClubCard(
                      club: club,
                      isJoined: _joinedClubs.contains(club.id),
                      onView: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ClubDetailsScreen(clubId: club.id),
                          ),
                        )
                            .then((_) => _loadJoined());
                      },
                      onJoin: () => _joinClub(club),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppTheme.textHint),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No clubs found for "$_searchQuery"'
                  : 'No clubs in this category',
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
}
