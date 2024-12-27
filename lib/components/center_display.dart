import 'package:flutter/material.dart';

class CenterDisplay extends StatelessWidget {
  const CenterDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png',
              height: 100), // Add your logo here
          SizedBox(height: 20),
          Text(
            'Welcome to Algerian History',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A6C5D)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'تعلم تاريخ الجزائر بطريقة فعالة',
            style: TextStyle(fontSize: 18, color: Color(0xFF7A6C5D)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
