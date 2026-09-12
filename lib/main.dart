import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'state/editor_state.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/landing_screen.dart';
import 'ui/screens/editor_screen.dart';
import 'ui/screens/export_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EditorState()),
      ],
      child: const TangRoopApp(),
    ),
  );
}

class TangRoopApp extends StatelessWidget {
  const TangRoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TangRoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: backgroundSoftLight,
        fontFamily: 'IbmPlexSansThai', // Defined in pubspec.yaml
        colorScheme: const ColorScheme.light(
          primary: primaryViolet,
          secondary: accentGold,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(
          onSplashFinished: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        '/home': (context) => LandingScreen(
          onStartClick: () => Navigator.pushNamed(context, '/editor'),
        ),
        '/editor': (context) => const EditorScreen(),
        '/export': (context) => const ExportScreen(),
      },
    );
  }
}
