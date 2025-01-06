import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/department_drpdown.dart';
import '../components/level_dropdown.dart';
import '../components/name_input.dart';
import '../components/welcome_message.dart';
import '../components/year_dropdown.dart';
import '../data/level_years.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../services/load_data.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic> _educationLevels = {};
  List<String> _years = [];
  List<String> _departments = [];
  bool _isLoading = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedLevel;
  String? _selectedYear;
  String? _selectedDepartment;
  String? _departmentError;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _levelError;
  String? _yearError;

  @override
  void initState() {
    super.initState();
    _loadEducationData();
  }

  Future<void> _loadEducationData() async {
    try {
      final levels = await _firestoreService.getEducationLevels();
      setState(() {
        _educationLevels = levels;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading education data: $e');
    }
  }

  Future<void> _loadYears(String level) async {
    try {
      final years = await _firestoreService.getYearsForLevel(level);
      setState(() {
        _years = years;
        _selectedYear = null;
        _departments = [];
      });
    } catch (e) {
      print('Error loading years: $e');
    }
  }

  Future<void> _loadDepartments(String level, String year) async {
    if (_shouldShowDepartment()) {
      try {
        final departments = await _firestoreService.getDepartments(level, year);
        setState(() {
          _departments = departments;
          _selectedDepartment = null;
        });
      } catch (e) {
        print('Error loading departments: $e');
      }
    }
  }

  void _validateInputs() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'يرجى إدخال اسمك' : null;
      _emailError =
          _emailController.text.isEmpty || !_emailController.text.contains('@')
              ? 'يرجى إدخال بريد إلكتروني صحيح'
              : null;
      _passwordError = _passwordController.text.isEmpty ||
              _passwordController.text.length < 6
          ? 'كلمة المرور يجب أن تكون على الأقل 6 أحرف'
          : null;
      _levelError =
          _selectedLevel == null ? 'يرجى اختيار المستوى الدراسي' : null;
      _yearError = _selectedYear == null ? 'يرجى اختيار السنة الدراسية' : null;
      _departmentError = _shouldShowDepartment() && _selectedDepartment == null
          ? 'يرجى اختيار التخصص'
          : null;
    });
  }

  bool _shouldShowDepartment() {
    return _selectedLevel == 'الثانوي' || _selectedLevel == 'الجامعي';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WelcomeMessage(),
              SizedBox(height: 20),
              NameInput(
                controller: _nameController,
                hintText: 'ادخل اسمك الكامل',
                labelText: 'الاسم',
              ),
              if (_nameError != null)
                Text(
                  _nameError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textDirection: TextDirection.rtl,
                ),
              SizedBox(height: 20),
              NameInput(
                controller: _emailController,
                hintText: 'ادخل بريدك الإلكتروني',
                labelText: 'البريد الإلكتروني',
              ),
              if (_emailError != null)
                Text(
                  _emailError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textDirection: TextDirection.rtl,
                ),
              SizedBox(height: 20),
              NameInput(
                controller: _passwordController,
                hintText: 'ادخل كلمة المرور',
                labelText: 'كلمة المرور',
                isPassword: true,
              ),
              if (_passwordError != null)
                Text(
                  _passwordError!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textDirection: TextDirection.rtl,
                ),
              SizedBox(height: 20),
              LevelDropdown(
                selectedLevel: _selectedLevel,
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    setState(() {
                      _selectedLevel = newValue;
                    });
                    await _loadYears(newValue);
                  }
                },
                levels: _educationLevels.keys.toList(),
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
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      setState(() {
                        _selectedYear = newValue;
                      });
                      if (_shouldShowDepartment()) {
                        await _loadDepartments(_selectedLevel!, newValue);
                      }
                    }
                  },
                  years: _years,
                ),
                if (_yearError != null)
                  Text(
                    _yearError!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textDirection: TextDirection.rtl,
                  ),
              ],
              if (_shouldShowDepartment() && _departments.isNotEmpty) ...[
                DepartmentDropdown(
                  selectedDepartment: _selectedDepartment,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  },
                  departments: _departments,
                ),
              ],
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    _validateInputs();
                    if (_nameError == null &&
                        _emailError == null &&
                        _passwordError == null &&
                        _levelError == null &&
                        _yearError == null) {
                      try {
                        final auth = FirebaseAuth.instance;
                        final methods = await auth
                            .fetchSignInMethodsForEmail(_emailController.text);
                        if (methods.isNotEmpty) {
                          // User already exists, log them in
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .login(
                            _emailController.text,
                            _passwordController.text,
                          );
                        } else {
                          // User does not exist, create a new account
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .signUp(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                            _selectedLevel!,
                            _selectedYear!,
                            _selectedDepartment,
                          );
                        }
                        // Navigate to the home screen
                        Navigator.pushNamed(context, '/home');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('حدث خطأ: $e'),
                          ),
                        );
                      }
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

  List<String> _getDepartmentsForLevel() {
    if (_selectedLevel == 'الثانوي') {
      return _selectedYear == 'الأولى ثانوي'
          ? ['علمي', 'أدبي']
          : [
              'رياضيات',
              'علوم تجريبية',
              'تقني رياضي',
              'تسيير وإقتصاد',
              'آداب وفلسفة',
              'لغات أجنبية'
            ];
    } else if (_selectedLevel == 'الجامعي') {
      return ['تاريخ', 'علوم سياسية', 'علوم إجتماعية', 'فلسفة', 'علوم إنسانية'];
    }
    return [];
  }
}
