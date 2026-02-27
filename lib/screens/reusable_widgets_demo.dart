import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/like_button.dart';

class ReusableWidgetsDemo extends StatelessWidget {
  const ReusableWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable Widgets Demo')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Custom InfoCard Reused Across Screens',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Profile',
            subtitle: 'View and manage your account',
            icon: Icons.person,
          ),
          InfoCard(
            title: 'Settings',
            subtitle: 'Customize app preferences',
            icon: Icons.settings,
          ),
          InfoCard(
            title: 'Notifications',
            subtitle: 'Manage notification settings',
            icon: Icons.notifications,
          ),
          InfoCard(
            title: 'About',
            subtitle: 'App information and version',
            icon: Icons.info,
          ),
          const SizedBox(height: 24),
          const Text(
            'Stateful LikeButton Widget',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feature Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Click the heart to like'),
                    ],
                  ),
                  const LikeButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Another Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Like button is reusable'),
                    ],
                  ),
                  const LikeButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
