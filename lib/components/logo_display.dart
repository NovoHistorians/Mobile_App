import 'package:flutter/material.dart';

class LogoDisplay extends StatelessWidget {
  const LogoDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo_novo.png',
            height: 250), // Add your logo here
        SizedBox(height: 10),
        Text(
          'تاريخنا.. إرثٌ يجمعنا ويُرشد طريقنا',
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
