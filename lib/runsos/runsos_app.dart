import 'package:flutter/material.dart';

import 'app/auth_gate.dart';
import 'features/home/runsos_home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/run/run_mode_screen.dart';
import 'features/sos/sos_map_screen.dart';
import 'features/auth/phone_login_screen.dart';
import 'theme/app_theme.dart';

class RunSosApp extends StatelessWidget {
  RunSosApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      navigatorKey: navigatorKey,
      routes: {
        '/': (_) => const AuthGate(),
        '/login': (_) => const PhoneLoginScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/home': (_) => const RunSosHomeScreen(),
        '/run': (_) => const RunModeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == SosMapScreen.routeName) {
          final args = settings.arguments;
          if (args is SosMapArgs) {
            return MaterialPageRoute(
              builder: (_) => SosMapScreen(args: args),
            );
          }
        }
        return null;
      },
    );
  }
}
