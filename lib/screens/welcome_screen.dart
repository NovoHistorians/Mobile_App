import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/level_dropdown.dart';
import '../components/name_input.dart';
import '../components/welcome_message.dart';
import '../components/year_dropdown.dart';
import '../data/chapters_data.dart';
import '../data/level_years.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();
  String? _selectedLevel;
  String? _selectedYear;

  String? _nameError;
  String? _levelError;
  String? _yearError;

  void _validateInputs() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'يرجى إدخال اسمك' : null;
      _levelError =
          _selectedLevel == null ? 'يرجى اختيار المستوى الدراسي' : null;
      _yearError = _selectedYear == null ? 'يرجى اختيار السنة الدراسية' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WelcomeMessage(),
              SizedBox(height: 20),
              NameInput(controller: _nameController),
              if (_nameError != null)
                Text(
                  _nameError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textDirection: TextDirection.rtl,
                ),
              SizedBox(height: 20),
              LevelDropdown(
                selectedLevel: _selectedLevel,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLevel = newValue;
                    _selectedYear = null;
                  });
                },
                levelYears: levelYears,
              ),
              if (_levelError != null)
                Text(
                  _levelError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textDirection: TextDirection.rtl,
                ),
              if (_selectedLevel != null) ...[
                SizedBox(height: 20),
                YearDropdown(
                  selectedYear: _selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue;
                    });
                  },
                  years: levelYears[_selectedLevel]!,
                ),
                if (_yearError != null)
                  Text(
                    _yearError!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textDirection: TextDirection.rtl,
                  ),
              ],
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _validateInputs();
                    if (_nameError == null &&
                        _levelError == null &&
                        _yearError == null) {
                      final user = UserModel(
                        name: _nameController.text,
                        level: _selectedLevel!,
                        year: _selectedYear!,
                        chapters: getChaptersForLevelAndYear(
                            _selectedLevel!, _selectedYear!),
                        avatar: 'assets/avatars/avatar_default.png',
                      );
                      Provider.of<UserProvider>(context, listen: false)
                          .setUser(user);
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A6C5D),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    textStyle:
                        TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'متابعة',
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
