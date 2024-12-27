import 'package:flutter/material.dart';

class LevelDropdown extends StatelessWidget {
  final String? selectedLevel;
  final Function(String?) onChanged;
  final Map<String, List<String>> levelYears;

  LevelDropdown({
    required this.selectedLevel,
    required this.onChanged,
    required this.levelYears,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          ' المستوى الدراسي',
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF3F414E),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Directionality(
          textDirection: TextDirection.rtl, // Set the dropdown direction to RTL
          child: Container(
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
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding: EdgeInsets.all(5),
                hint: Text(
                  "اختر من القائمة",
                  textDirection: TextDirection.rtl, // Keep hint text RTL
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: selectedLevel,
                items: levelYears.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width:
                          MediaQuery.of(context).size.width - 0, // Adjust width
                      child: Text(
                        value,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7A6C5D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                dropdownColor:
                    Colors.white, // Optional: Change dropdown background color
                isExpanded: true, // Ensures the dropdown takes full width
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF7A6C5D)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
