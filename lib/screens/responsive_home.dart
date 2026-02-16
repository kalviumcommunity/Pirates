import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    final bool isTablet = width > 600;
    final bool isLandscape = width > height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Home"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                color: Colors.blue.shade100,
                child: Text(
                  "Welcome to Responsive UI",
                  style: TextStyle(
                    fontSize: isTablet ? 26 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: isTablet || isLandscape
                    ? _buildGridLayout(isTablet)
                    : _buildListLayout(),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 20 : 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 18 : 14,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: isTablet ? 18 : 14),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildListLayout() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _cardItem(index);
      },
    );
  }

  Widget _buildGridLayout(bool isTablet) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _cardItem(index);
      },
    );
  }

  Widget _cardItem(int index) {
    return Card(
      elevation: 3,
      child: Center(
        child: FittedBox(
          child: Text(
            "Item ${index + 1}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
