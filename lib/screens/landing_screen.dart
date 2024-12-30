import 'package:flutter/material.dart';
import '../components/logo_display.dart';
import '../components/start_button.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7A6C5D),
      body: Column(
        children: [
          Spacer(
            flex: 2,
          ), // Pushes the logo to the center
          const LogoDisplay(),
          Spacer(), // Pushes the button to the bottom
          StartButton(context),
          Padding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }
}
