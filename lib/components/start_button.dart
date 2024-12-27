import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final BuildContext context;

  StartButton(this.context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/welcome');
        },
        child: Text(
          'مرحبا بك',
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC17C74),
          padding: EdgeInsets.symmetric(vertical: 15),
          textStyle: TextStyle(fontSize: 18),
          minimumSize: Size(double.infinity, 50), // Full width
        ),
      ),
    );
  }
}
