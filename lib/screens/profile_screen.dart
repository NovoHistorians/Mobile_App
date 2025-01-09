import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/department_drpdown.dart';
import '../components/error_message.dart';
import '../components/level_dropdown.dart';
import '../components/year_dropdown.dart';
import '../data/level_years.dart';
import '../providers/user_provider.dart';
import '../data/avatars.dart';
import '../services/load_data.dart';
import '../widgets/custom_scaffold.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_service_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic> _educationLevels = {};
  List<String> _years = [];
  List<String> _departments = [];
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  String? _selectedLevel;
  String? _selectedYear;
  String? _selectedAvatar;
  String? _selectedDepartment;
  bool _isDarkMode = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final levels = await _firestoreService.getEducationLevels();

      if (user != null) {
        _nameController.text = user.name;
        _selectedLevel = user.level;
        _selectedAvatar = user.avatar;

        if (_selectedLevel != null) {
          final years =
              await _firestoreService.getYearsForLevel(_selectedLevel!);
          _years = years;
          _selectedYear = user.year;

          if (_shouldShowDepartment()) {
            final departments = await _firestoreService.getDepartments(
                _selectedLevel!, _selectedYear!);
            _departments = departments;
            _selectedDepartment = user.department;
          }
        }
      }

      setState(() {
        _educationLevels = levels;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
      setState(() => _isLoading = false);
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

  bool _shouldShowDepartment() {
    return _selectedLevel == 'الثانوي' || _selectedLevel == 'الجامعي';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "الملف الشخصي",
      shouldPop: true, // Allow default back navigation
      redirectToHome: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Profile Header
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF7A6C5D),
                        Color(0xFF9B8B7A),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CirclePatternPainter(),
                        ),
                      ),
                      Center(
                        child: _buildProfileAvatar(),
                      ),
                    ],
                  ),
                ),

                // Main Content with Padding for Bottom Button
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 80, // Add padding for the floating save button
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Personal Information Card
                      _buildSection(
                        'المعلومات الشخصية',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProfileField(
                              icon: Icons.person,
                              title: 'الاسم',
                              child: _buildTextField(),
                            ),
                            SizedBox(height: 16),
                            _buildProfileField(
                              icon: Icons.school,
                              title: 'المستوى',
                              child: _buildLevelDropdown(),
                            ),
                            if (_selectedLevel != null) ...[
                              SizedBox(height: 16),
                              _buildProfileField(
                                icon: Icons.calendar_today,
                                title: 'السنة الدراسية',
                                child: _buildYearDropdown(),
                              ),
                            ],
                            if (_shouldShowDepartment() &&
                                _selectedYear != null) ...[
                              SizedBox(height: 16),
                              _buildProfileField(
                                icon: Icons.class_,
                                title: 'التخصص',
                                child: _buildDepartmentDropdown(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Settings Section
                      _buildSection(
                        'الإعدادات',
                        Column(
                          children: [
                            _buildSettingsItem(
                              icon: Icons.dark_mode,
                              title: 'الوضع الداكن',
                              trailing: Switch(
                                value: _isDarkMode,
                                onChanged: (value) {
                                  /*setState(() {
                                    _isDarkMode = value;
                                  });*/
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'قريباً',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7A6C5D),
                                        ),
                                      ),
                                      content: Text(
                                        'هذه الميزة ستتوفر قريباً. شكراً لتفهمك!',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            'حسناً',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                color: Color(0xFF7A6C5D)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                activeColor: Color(0xFF7A6C5D),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'قريباً',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7A6C5D),
                                      ),
                                    ),
                                    content: Text(
                                      'هذه الميزة ستتوفر قريباً. شكراً لتفهمك!',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'حسناً',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: Color(0xFF7A6C5D)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Links Section
                      _buildSection(
                        'روابط مهمة',
                        Column(
                          children: [
                            _buildLinkItem(
                              icon: Icons.help_outline,
                              title: 'المساعدة والدعم',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HelpSupportScreen(),
                                  ),
                                );
                              },
                            ),
                            Divider(height: 1),
                            _buildLinkItem(
                              icon: Icons.description_outlined,
                              title: 'شروط الخدمة',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsServiceScreen(),
                                  ),
                                );
                              },
                            ),
                            Divider(height: 1),
                            _buildLinkItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'سياسة الخصوصية',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating Save Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 15,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProfileSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7A6C5D),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'حفظ التغييرات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<UserProvider>(context, listen: false)
                          .logout();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 168, 154, 138),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveProfileSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A6C5D),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'حفظ التغييرات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<UserProvider>(context, listen: false)
                      .logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A6C5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              _selectedAvatar ?? 'assets/avatars/avatar_default.png',
            ),
            radius: 50,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showAvatarPicker(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: Color(0xFF7A6C5D),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A6C5D),
              ),
            ),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: LevelDropdown(
        selectedLevel: _selectedLevel,
        onChanged: (String? newValue) async {
          if (newValue != null) {
            setState(() {
              _selectedLevel = newValue;
              _selectedYear = null;
              _selectedDepartment = null;
              _years = [];
              _departments = [];
            });
            await _loadYears(newValue);
          }
        },
        levels: _educationLevels.keys.toList(),
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: DepartmentDropdown(
        selectedDepartment: _selectedDepartment,
        onChanged: (String? newValue) {
          setState(() {
            _selectedDepartment = newValue;
          });
        },
        departments: _departments,
      ),
    );
  }

  Future<void> _loadYears(String level) async {
    try {
      final years = await _firestoreService.getYearsForLevel(level);
      setState(() => _years = years);
    } catch (e) {
      print('Error loading years: $e');
    }
  }

  Widget _buildYearDropdown() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: YearDropdown(
        selectedYear: _selectedYear,
        onChanged: (String? newValue) async {
          if (newValue != null) {
            setState(() {
              _selectedYear = newValue;
              _selectedDepartment = null;
              _departments = [];
            });
            if (_shouldShowDepartment()) {
              await _loadDepartments(_selectedLevel!, newValue);
            }
          }
        },
        years: _years,
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF7A6C5D)),
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_back_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showAvatarPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 500, // Increased height to accommodate grid
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFEBEBD3), // Using the theme's background color
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.face,
                color: Color(0xFF7A6C5D),
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'اختر صورة شخصية',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A6C5D),
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(12),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: avatars.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = avatars[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedAvatar == avatars[index]
                                  ? Color(0xFF7A6C5D)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: _selectedAvatar == avatars[index]
                                ? Color(0xFF7A6C5D).withOpacity(0.1)
                                : Colors.white,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Image.asset(
                            avatars[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A6C5D),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: Color(0xFF7A6C5D), size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF7A6C5D)),
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _saveProfileSettings() {
    if (_selectedLevel != null && _selectedYear != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      if (user != null) {
        // Only set department if it's required for the level
        if (_shouldShowDepartment()) {
          if (_selectedDepartment != null) {
            user.department = _selectedDepartment!;
          } else {
            SamsungNotification.show(
              context,
              message: 'يرجى اختيار التخصص',
              icon: Icons.error_outline_outlined,
              duration: const Duration(seconds: 5),
              type: NotificationType.warning,
            );
            return;
          }
        } else {
          // Clear department if not applicable for current level
          user.department = '';
        }
        user.name = _nameController.text;
        user.level = _selectedLevel!;
        user.year = _selectedYear!;
        user.avatar = _selectedAvatar ?? user.avatar;
        userProvider.updateUser(user);

        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFEBEBD3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF7A6C5D),
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'تم حفظ التغييرات بنجاح',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A6C5D),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7A6C5D),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'حسناً',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      SamsungNotification.show(
        context,
        message: 'يرجى اختيار المستوى والسنة الدراسية',
        icon: Icons.error_outline_outlined,
        duration: const Duration(seconds: 5),
        type: NotificationType.warning,
      );
    }
  }
}

// Custom painter for the circle pattern background
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final radius = size.width / 8;
    for (var i = 0; i < 20; i++) {
      final x = (i * radius * 1.5) % size.width;
      final y = ((i * radius * 1.5) / size.width).floor() * radius * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
