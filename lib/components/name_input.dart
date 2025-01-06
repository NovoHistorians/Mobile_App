import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final String labelText;

  NameInput({
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF3F414E),
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 2,
                spreadRadius: 0,
                offset: Offset(5, 5),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            obscureText: isPassword, // Hide text for password fields
            decoration: InputDecoration(
              hintText: hintText,
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // Remove default border
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {
                        // Toggle password visibility (optional)
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}