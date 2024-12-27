import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  final TextEditingController controller;

  NameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          ' الاسم',
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF3F414E),
              fontWeight: FontWeight.bold),
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
            decoration: InputDecoration(
              hintText: 'ادخل اسمك الكامل',
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // Remove default border
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
