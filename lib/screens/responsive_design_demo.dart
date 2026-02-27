import 'package:flutter/material.dart';

class ResponsiveDesignDemo extends StatelessWidget {
  const ResponsiveDesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Demo'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header: Responsive Container
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.15,
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      isMobile ? 'Mobile View' : 'Tablet View',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Proportional Container
                Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 24),
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.1,
                    color: Colors.tealAccent,
                    child: const Center(
                      child: Text(
                        'Proportional Container (80% width, 10% height)',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                // Conditional Layout: Column for mobile, Row for tablet
                Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 24),
                  child: isMobile
                      ? _buildMobileLayout(screenWidth, screenHeight)
                      : _buildTabletLayout(screenWidth, screenHeight),
                ),

                // Info Display based on layout
                Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 24),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Screen Information',
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Width: ${screenWidth.toStringAsFixed(0)} px',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Height: ${screenHeight.toStringAsFixed(0)} px',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Layout: ${isMobile ? 'Portrait (Mobile)' : 'Landscape/Tablet'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Device Type: ${constraints.maxWidth < 600 ? 'Mobile' : 'Tablet/Desktop'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(double screenWidth, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: screenWidth * 0.85,
          height: screenHeight * 0.12,
          color: Colors.orangeAccent,
          child: const Center(
            child: Text(
              'Mobile Layout\nColumn View',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: screenWidth * 0.85,
          height: screenHeight * 0.12,
          color: Colors.lightBlueAccent,
          child: const Center(
            child: Text(
              'Stack vertically\non small screens',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.15,
          color: Colors.orangeAccent,
          child: const Center(
            child: Text(
              'Tablet Left\nPanel',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.15,
          color: Colors.lightBlueAccent,
          child: const Center(
            child: Text(
              'Tablet Right\nPanel',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
