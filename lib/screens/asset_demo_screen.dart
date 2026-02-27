import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets & Icons Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Local Image Asset
              const Text(
                'Local Image Assets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/logo.svg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                'App Logo from Assets',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Banner Image
              const Text(
                'Banner Image',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/banner.svg',
                width: 300,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32),

              // Flutter Material Icons
              const Text(
                'Material Design Icons',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 48),
                      const SizedBox(height: 8),
                      const Text('Star'),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      const Text('Favorite'),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.green, size: 48),
                      const SizedBox(height: 8),
                      const Text('Like'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Platform-specific Icons
              const Text(
                'Platform Icons',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.android, color: Colors.green, size: 48),
                      const SizedBox(height: 8),
                      const Text('Android'),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      Icon(Icons.apple, color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      const Text('iOS'),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      Icon(CupertinoIcons.heart, color: Colors.pink, size: 48),
                      const SizedBox(height: 8),
                      const Text('Cupertino'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Background Image Demo
              const Text(
                'Background Image Container',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'Custom Container\nwith Teal Border',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Custom Icon Grid
              const Text(
                'Icon Grid Display',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 48),
                children: [
                  _buildIconTile(Icons.settings, Colors.blue, 'Settings'),
                  _buildIconTile(Icons.notifications, Colors.orange, 'Alerts'),
                  _buildIconTile(Icons.security, Colors.green, 'Security'),
                  _buildIconTile(Icons.language, Colors.purple, 'Language'),
                  _buildIconTile(Icons.help, Colors.red, 'Help'),
                  _buildIconTile(Icons.logout, Colors.grey, 'Logout'),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconTile(IconData icon, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
