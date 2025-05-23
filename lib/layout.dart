import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final String title;

  final Widget child;

  // show the hamburger menu or not
  final bool showDrawer;

  const Layout(
      {super.key,
      required this.title,
      required this.child,
      this.showDrawer = true});

  final darkCapgeminiBlue = const Color(0xFF006FAC);

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    // Set padding and margin based on screen width
    final bool isMobile = screenWidth < 600;

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/JnJ.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text("Demo JnJ - $title"),
                SizedBox(width: 8),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              color: Colors.white.withOpacity(0.9),
              // Set margin and padding to 0 for mobile devices
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
                  // Logo and Title
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: SizedBox(
                      height: 55,
                      child: Image.asset('images/logo_3.png', semanticLabel: 'JnJ logo'),
                    ),
                  ),
                  Text(
                    "Demo JnJ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: darkCapgeminiBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.grey, indent: 8, endIndent: 8),

                  // Navigation Items
                  ListTile(
                    leading: Icon(Icons.download, color: darkCapgeminiBlue),
                    title: Text("Scrape"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/scrape');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.tune, color: darkCapgeminiBlue),
                    title: Text("Parameters"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/parameters');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.error_outline, color: darkCapgeminiBlue),
                    title: Text("Errors"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/errors');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: darkCapgeminiBlue),
                    title: Text("About"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/about');
                    },
                  ),
                ],
              ),
            )
          : null,
        ),
      ),
    );
  }
}
