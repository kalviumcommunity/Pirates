import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Layout')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.lightBlueAccent,
              child: const Center(child: Text('Header Section')),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.amber,
                            child: const Center(child: Text('Left Panel')),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            color: Colors.greenAccent,
                            child: const Center(child: Text('Right Panel')),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.amber,
                            child: const Center(child: Text('Left Panel')),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            color: Colors.greenAccent,
                            child: const Center(child: Text('Right Panel')),
                          ),
                        ),
                      ],
                    ),
            ),
            if (!isWide) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 60,
                color: Colors.deepPurpleAccent,
                child: const Center(child: Text('Footer Section')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
