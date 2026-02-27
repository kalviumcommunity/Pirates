import 'package:flutter/material.dart';

class ImplicitAnimationsDemo extends StatefulWidget {
  const ImplicitAnimationsDemo({super.key});

  @override
  State<ImplicitAnimationsDemo> createState() => _ImplicitAnimationsDemoState();
}

class _ImplicitAnimationsDemoState extends State<ImplicitAnimationsDemo> {
  bool _toggled = false;
  bool _opacityToggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AnimatedContainer Demo
              const SizedBox(height: 24),
              const Text(
                'AnimatedContainer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: AnimatedContainer(
                  width: _toggled ? 200 : 100,
                  height: _toggled ? 100 : 200,
                  color: _toggled ? Colors.teal : Colors.orange,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: const Center(
                    child: Text(
                      'Tap FAB!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Smoothly transitions size and color',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // AnimatedOpacity Demo
              const Text(
                'AnimatedOpacity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _opacityToggled ? 1.0 : 0.2,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Fade Effect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Fades in and out via opacity',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // AnimatedAlign Demo
              const Text(
                'AnimatedAlign',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 300,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedAlign(
                    alignment: _toggled ? Alignment.centerRight : Alignment.centerLeft,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Smoothly aligns position across container',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _toggled = !_toggled;
                      });
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Toggle Animations'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _opacityToggled = !_opacityToggled;
                      });
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Toggle Opacity'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
