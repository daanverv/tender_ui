import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tender_ui/widgets/tender_screen.dart';
import 'package:tender_ui/widgets/tender_widget.dart';
import 'home.dart'; 

void main() {
  runApp(const JnJApp());
}

class JnJApp extends StatelessWidget {
  const JnJApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: '/scrape',
          builder: (context, state) => const TenderScreen(),
        ),
        GoRoute(
          path: '/parameters',
          builder: (context, state) => const PlaceholderScreen(title: 'Parameters'),
        ),
        GoRoute(
          path: '/errors',
          builder: (context, state) => const PlaceholderScreen(title: 'Errors'),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const PlaceholderScreen(title: 'About'),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'J&J Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}