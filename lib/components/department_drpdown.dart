import 'package:flutter/material.dart';

class DepartmentDropdown extends StatelessWidget {
  final String? selectedDepartment;
  final Function(String?) onChanged;
  final List<String> departments;

  const DepartmentDropdown({
    Key? key,
    required this.selectedDepartment,
    required this.onChanged,
    required this.departments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          ' اختر تخصصك:',
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF3F414E),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Directionality(
          textDirection: TextDirection.rtl,
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
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: selectedDepartment,
                items: departments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 0,
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
                dropdownColor: Colors.white,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF7A6C5D)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
