import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runsos/runsos/theme/app_theme.dart';
import 'package:runsos/runsos/widgets/sos_button.dart';

void main() {
  testWidgets('SOS button renders its label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: Center(
            child: SosButton(
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('SOS'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
