import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Layout extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? fab;
  final bool showDrawer;

  const Layout({
    super.key,
    required this.title,
    required this.child,
    this.fab,
    this.showDrawer = true,
  });

  final darkCapgeminiBlue = const Color(0xFF006FAC);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background_1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Demo JnJ - $title"),
              const SizedBox(width: 8),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            color: Colors.white.withOpacity(0.9),
            margin: isMobile ? EdgeInsets.zero : const EdgeInsets.all(16),
            padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(16),
            width: isMobile ? screenWidth : 800,
            child: child,
          ),
        ),
        drawer: showDrawer
            ? Drawer(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: SizedBox(
                        height: 55,
                        child: Image.asset('images/logo_3.png', semanticLabel: 'JnJ logo'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Demo JnJ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: darkCapgeminiBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey, indent: 8, endIndent: 8),

                    ListTile(
                      leading: Icon(Icons.download, color: darkCapgeminiBlue),
                      title: const Text("Scrape"),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/scrape');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.tune, color: darkCapgeminiBlue),
                      title: const Text("Parameters"),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/parameters');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.error_outline, color: darkCapgeminiBlue),
                      title: const Text("Errors"),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/errors');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline, color: darkCapgeminiBlue),
                      title: const Text("About"),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/about');
                      },
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
