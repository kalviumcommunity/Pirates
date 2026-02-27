import 'package:flutter/material.dart';

class NavigationHome extends StatelessWidget {
  const NavigationHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/navSecond', arguments: 'Hello from Home!');
          },
          child: const Text('Go to Second Screen'),
        ),
      ),
    );
  }
}
