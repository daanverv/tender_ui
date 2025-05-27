import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

const Color jnjRed = Color(0xFFD71920);

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, jnjRed.withOpacity(0.01)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            headerSection(context, screenWidth, isMobile),
            const SizedBox(height: 30),
            welcomeSection(screenWidth),
            featureGrid(context, screenWidth, isMobile),
            footerSection(screenWidth, context),
          ],
        ),
      ),
    );
  }

  Widget headerSection(BuildContext context, double screenWidth, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'images/cap.png',
                width: isMobile ? screenWidth * 0.3 : screenWidth * 0.15,
              ),
            ],
          ),
          Image.asset(
            'images/jnj_1.png',
            width: isMobile ? screenWidth * 0.3 : screenWidth * 0.15,
          ),
        ],
      ),
    );
  }

  Widget socialIcon(IconData icon, String url) => IconButton(
        icon: Icon(icon, color: jnjRed, size: 26),
        onPressed: () async => launchUrl(Uri.parse(url)),
      );

  Widget welcomeSection(double screenWidth) => Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: 40),
        child: Column(
          children: [
            Text(
              "Welcome to the J&J webscraping application!",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: jnjRed,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Use the menu or cards below to explore modules.",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget featureGrid(BuildContext context, double screenWidth, bool isMobile) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GridView.count(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.4, 
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildFeatureCards(context),
      )
      );

  Widget footerSection(double screenWidth, BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Text(
              'Empowering health through innovation and care.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: jnjRed,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Image.asset('images/logo_3.png', width: 60),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => context.go('/about'),
              child: Text('About', style: GoogleFonts.poppins(color: jnjRed)),
            ),
          ],
        ),
      );

  List<Widget> _buildFeatureCards(BuildContext context) => [
        featureCard(context, 'Scrape', Icons.download, '/scrape'),
        featureCard(context, 'Parameters', Icons.tune, '/parameters'),
        featureCard(context, 'Errors', Icons.error_outline, '/errors'),
        featureCard(context, 'About', Icons.info_outline, '/about'),
      ];

  Widget featureCard(BuildContext context, String title, IconData icon, String route) => InkWell(
  onTap: () => context.go(route),
  child: Container(
    padding: const EdgeInsets.all(8), 
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: jnjRed.withOpacity(0.3), width: 1.5),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 36, color: jnjRed), // Smaller icon
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12, // Smaller font
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
);

}
