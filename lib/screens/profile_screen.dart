import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/level_dropdown.dart';
import '../components/year_dropdown.dart';
import '../data/level_years.dart';
import '../providers/user_provider.dart';
import '../data/avatars.dart';
import '../widgets/custom_scaffold.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_service_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedLevel;
  String? _selectedYear;
  String? _selectedAvatar;
  bool _isDarkMode = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _selectedLevel = user.level;
      _selectedYear = user.year;
      _selectedAvatar = user.avatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "الملف الشخصي",
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
            ),
          ),
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
        onChanged: (String? newValue) {
          setState(() {
            _selectedLevel = newValue;
            _selectedYear = null;
          });
        },
        levelYears: levelYears,
      ),
    );
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
        onChanged: (String? newValue) {
          setState(() {
            _selectedYear = newValue;
          });
        },
        years: levelYears[_selectedLevel] ?? [],
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
                  Icons.warning,
                  color: Color(0xFF7A6C5D),
                  size: 50,
                ),
                SizedBox(height: 10),
                Text(
                  'يرجى اختيار المستوى والسنة الدراسية',
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
