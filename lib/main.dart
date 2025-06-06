import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tender_ui/home.dart';
import 'package:tender_ui/layout.dart';
import 'package:tender_ui/widgets/add_website.dart';
import 'package:tender_ui/widgets/clear_overview.dart';
import 'package:tender_ui/widgets/errors.dart';
import 'package:tender_ui/widgets/parameters.dart';
import 'package:tender_ui/widgets/scrape_launcher.dart';
import 'package:tender_ui/widgets/scrape_site.dart';
import 'package:tender_ui/widgets/scrape_with_filters.dart';
import 'package:tender_ui/widgets/tender_screen.dart';


void main() {
  runApp(const JnJApp());
}

class JnJApp extends StatelessWidget {
  const JnJApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
                   GoRoute(
            path: '/tender_overview',
            builder: (context, state) {
              final websiteIdStr = state.uri.queryParameters['websiteId'];
              final websiteId = websiteIdStr != null ? int.tryParse(websiteIdStr) : null;

              if (websiteId == null) {
                return const Scaffold(
                  body: Center(child: Text('Invalid or missing websiteId')),
                );
              }

              return TenderOverviewPage(websiteId: websiteId);
            },
          ),
        ShellRoute(
          builder: (context, state, child) {
            final location = state.fullPath ?? '/';
            final title = _getTitleFromPath(location);
            return Layout(title: title, child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Home(),
            ),
            GoRoute(
              path: '/scrape',
              builder: (context, state) => const ScrapePage(),
            ),
            GoRoute(
              path: '/parameters',
              builder: (context, state) =>
                  const Parameters(),
            ),
            GoRoute(
              path: '/errors',
              builder: (context, state) =>
                  Errors(),
            ),
            GoRoute(
              path: '/about',
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'About'),
            ),
            GoRoute(
              path: '/tenders',
              builder: (context, state) =>
                  const TenderScreen(),
            ),
            GoRoute(
              path: '/scrape_website',
              builder: (context, state) =>
                  const ScrapeLauncher(),
            ),
            GoRoute(
              path: '/scrape_with_filters',
              builder: (context, state) =>
                  const ScrapeWithFilterPage(),
            ),
            GoRoute(
              path: '/add_website',
              builder: (context, state) =>
                  const AddWebsitePage(),
            ),
          ],
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

  String _getTitleFromPath(String path) {
    switch (path) {
      case '/':
        return 'Home';
      case '/scrape':
        return 'Scrape';
      case '/parameters':
        return 'Parameters';
      case '/errors':
        return 'Errors';
      case '/about':
        return 'About';
      default:
        return 'J&J';
    }
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
