// lib/screens/about_screen.dart
// About screen with app info and viva-relevant details

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: AppTheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // App logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🎓', style: TextStyle(fontSize: 50)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppConstants.appFullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Version ${AppConstants.appVersion}',
              style: const TextStyle(fontSize: 13, color: AppTheme.textHint),
            ),
            const SizedBox(height: 4),
            const Text(
              AppConstants.appDepartment,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Built with section
            _sectionCard(
              title: 'Built With',
              items: [
                _techRow('⚡', 'Flutter', '3.47.6 — UI Framework'),
                _techRow('🎯', 'Dart', '3.13.5 — Programming Language'),
                _techRow('💾', 'SharedPreferences', 'Local Data Persistence'),
              ],
            ),
            const SizedBox(height: 16),
            // Features section
            _sectionCard(
              title: 'Features',
              items: [
                _featureRow(Icons.login, 'Login & Authentication'),
                _featureRow(Icons.dashboard_outlined, 'Dynamic Dashboard'),
                _featureRow(Icons.groups_outlined, 'Club Management'),
                _featureRow(Icons.star_outline, 'Club Membership'),
                _featureRow(Icons.event_outlined, 'Events & Registration'),
                _featureRow(Icons.search, 'Search Functionality'),
                _featureRow(Icons.save_outlined, 'Local Data Persistence'),
                _featureRow(Icons.check_circle_outline, 'Input Validation'),
              ],
            ),
            const SizedBox(height: 16),
            // Tech concepts
            _sectionCard(
              title: 'Flutter Concepts Demonstrated',
              items: [
                _conceptRow('StatefulWidget & StatelessWidget'),
                _conceptRow('setState for state management'),
                _conceptRow('Navigator & Routes'),
                _conceptRow('Form validation'),
                _conceptRow('SharedPreferences storage'),
                _conceptRow('Animations (AnimationController)'),
                _conceptRow('CustomScrollView & SliverAppBar'),
                _conceptRow('Bottom Navigation Bar'),
                _conceptRow('TabBar & TabBarView'),
                _conceptRow('Future & async/await'),
                _conceptRow('Singleton service pattern'),
                _conceptRow('Reusable widgets'),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                children: [
                  Text(
                    '🎓 B.Tech Flutter Laboratory Project',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'College Club Management System',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...items,
        ],
      ),
    );
  }

  Widget _techRow(String emoji, String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                Text(description,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 10),
          Text(feature,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _conceptRow(String concept) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 15, color: AppTheme.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(concept,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textPrimary)),
          ),
        ],
      ),
    );
  }
}
