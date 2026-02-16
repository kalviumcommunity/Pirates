import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Concept-3: Design Thinking & Responsive UI
// ---------------------------------------------------------------------------
// This app demonstrates how to translate a design concept into a responsive
// Flutter application that adapts to different screen sizes.

void main() {
  runApp(const SmartUIApp());
}

class SmartUIApp extends StatelessWidget {
  const SmartUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart UI Demo',
      theme: ThemeData(
        // Material 3 provides a modern, "smart" aesthetic out of the box
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const ResponsiveDashboard(),
    );
  }
}

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------------
    // 4. Apply Responsive & Adaptive Design
    // -----------------------------------------------------------------------
    // We use MediaQuery to obtain the screen metrics.
    // If width > 600, we assume a tablet/desktop context.
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Mobile Interface'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      // Switch layouts based on screen width
      body: isWideScreen ? const WideLayout() : const MobileLayout(),
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile Layout (Vertical Column)
// ---------------------------------------------------------------------------
class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          WelcomeCard(),
          SizedBox(height: 16),
          StatsSection(),
          SizedBox(height: 16),
          RecentActivityList(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wide/Tablet Layout (Horizontal Row)
// ---------------------------------------------------------------------------
class WideLayout extends StatelessWidget {
  const WideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar / Main Info Area
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                WelcomeCard(),
                SizedBox(height: 24),
                StatsSection(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Content Area
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const RecentActivityList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable UI Components (Translating Design Elements)
// ---------------------------------------------------------------------------

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.rocket_launch, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text(
              'Welcome to Flutter Design',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Translating Figma concepts into responsive code.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Using simple Row for mobile-friendly stats
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(context, 'Tasks', '12'),
        _buildStatItem(context, 'Pending', '4'),
        _buildStatItem(context, 'Done', '8'),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListView.separated(
          shrinkWrap: true, // Important when inside another scroll view
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text('Design Task #${index + 1}'),
              subtitle: const Text('Completed wireframing stage'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            );
          },
        ),
      ],
    );
  }
}
