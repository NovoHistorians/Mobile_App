import 'package:flutter/material.dart';

class LogoDisplay extends StatelessWidget {
  const LogoDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo_novo.png',
            height: 500), // Add your logo here
        //SizedBox(height: 20),
        /*Text(
          'تعلم تاريخ الجزائر بطريقة فعالة',
          style: TextStyle(fontSize: 24, color: Colors.black),
          textAlign: TextAlign.center,
        ),*/
      ],
    );
  }
}
