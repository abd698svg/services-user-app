import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _secureStorage = const FlutterSecureStorage();
  
  bool _isLoading = true;
  String _userName = 'جاري التحميل...';
  String _userEmail = '...';
  String _studentId = '...';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _secureStorage.read(key: 'auth_token');

      if (token == null) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
        return;
      }

      final url = Uri.parse('http://127.0.0.1:8000/api/user');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        
        // استخراج بيانات المستخدم بمرونة بغض النظر عن طريقة إرجاعها من Laravel
        Map<String, dynamic> userData = {};
        if (decodedData is Map<String, dynamic>) {
          if (decodedData.containsKey('user') && decodedData['user'] is Map) {
            userData = Map<String, dynamic>.from(decodedData['user']);
          } else if (decodedData.containsKey('data') && decodedData['data'] is Map) {
            userData = Map<String, dynamic>.from(decodedData['data']);
          } else {
            userData = decodedData;
          }
        }

        if (mounted) {
          setState(() {
            // البحث عن الاسم بأكثر من احتمال (name, full_name, username)
            _userName = userData['name'] ?? 
                        userData['full_name'] ?? 
                        userData['username'] ?? 
                        'مستخدم جامعي';
                        
            _userEmail = userData['email'] ?? 'البريد غير متوفر';
            
            _studentId = userData['student_id']?.toString() ?? 
                         userData['id']?.toString() ?? 
                         'غير متوفر';
                         
            _isLoading = false;
          });
        }
      } else {
        // انتهت صلاحية الجلسة أو التوكن غير صالح
        await _secureStorage.delete(key: 'auth_token');
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تعذر الاتصال بالخادم لجلب بيانات الحساب.';
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _handleLogout() async {
    // Show loading indicator or dialog if needed
    try {
      final token = await _secureStorage.read(key: 'auth_token');

      if (token != null) {
        final url = Uri.parse('http://127.0.0.1:8000/api/logout');
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (_) {
      // Ignore network errors on logout and proceed to clear local session
    } finally {
      // Clear local storage token
      await _secureStorage.delete(key: 'auth_token');

      if (mounted) {
        // Navigate to login screen and clear all history stack
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF57534E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE7DDD2), width: 1.5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => Navigator.pop(context),
                              child: const Center(
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF57534E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color(0xFFDC2626), // Error red
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.pop(context);
                                _handleLogout();
                              },
                              child: const Center(
                                child: Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFBF7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'الملف الشخصي',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1917),
            ),
          ),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(color: Color(0xFFF1E7DD), height: 1, thickness: 1),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF97316),
                  strokeWidth: 3,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: 14,
                                  color: Color(0xFF991B1B),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _fetchUserData,
                              child: const Text('إعادة المحاولة', style: TextStyle(color: Color(0xFFC2410C))),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Profile Avatar
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(0xFFFFEDD5),
                      child: Text(
                        _userName.isNotEmpty ? _userName.substring(0, 1) : 'U',
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC2410C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1917),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 14,
                        color: Color(0xFF78716C),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1E7DD)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المعلومات الأكاديمية',
                            style: TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1917),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow('الرقم الجامعي', _studentId),
                          const Divider(height: 24, color: Color(0xFFF1E7DD)),
                          _buildInfoRow('البريد الإلكتروني', _userEmail),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1E7DD)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit_outlined, color: Color(0xFF1C1917)),
                            title: const Text(
                              'تعديل الاسم',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF78716C)),
                            onTap: () async {
                              await Navigator.pushNamed(context, '/edit_profile');
                              _fetchUserData(); // Refresh profile data upon return
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFF1E7DD)),
                          ListTile(
                            leading: const Icon(Icons.lock_outline, color: Color(0xFF1C1917)),
                            title: const Text(
                              'تغيير كلمة المرور',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF78716C)),
                            onTap: () {
                              Navigator.pushNamed(context, '/change_password');
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFF1E7DD)),
                          ListTile(
                            leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
                            title: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                            onTap: _showLogoutDialog,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: const _CustomBottomNavBar(activeTabIndex: 2),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14,
            color: Color(0xFF78716C),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1917),
          ),
        ),
      ],
    );
  }
}

// Unified Bottom Navigation Bar
class _CustomBottomNavBar extends StatelessWidget {
  final int activeTabIndex;
  const _CustomBottomNavBar({Key? key, this.activeTabIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1E7DD), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1AC2410C),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.home,
              label: 'الرئيسية',
              isActive: activeTabIndex == 0,
              onTap: () {
                if (activeTabIndex != 0) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
            _buildNavItem(
              context: context,
              icon: Icons.receipt_long,
              label: 'طلباتي',
              isActive: activeTabIndex == 1,
              onTap: () {
                if (activeTabIndex != 1) {
                  Navigator.pushReplacementNamed(context, '/my_requests');
                }
              },
            ),
            _buildNavItem(
              context: context,
              icon: Icons.add_circle_outline_rounded,
              label: 'إضافة طلب',
              isActive: false,
              isAction: true,
              onTap: () {
                Navigator.pushNamed(context, '/new_request');
              },
            ),
            _buildNavItem(
              context: context,
              icon: Icons.person,
              label: 'الملف الشخصي',
              isActive: activeTabIndex == 2,
              onTap: () {
                if (activeTabIndex != 2) {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    bool isAction = false,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isAction
                    ? const Color(0xFFFFEDD5)
                    : (isActive ? const Color(0xFFFFEDD5) : Colors.transparent),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isAction
                    ? const Color(0xFFF97316)
                    : (isActive ? const Color(0xFFC2410C) : const Color(0xFF78716C)),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 11,
                fontWeight: isActive || isAction ? FontWeight.w700 : FontWeight.w500,
                color: isAction
                    ? const Color(0xFFC2410C)
                    : (isActive ? const Color(0xFFC2410C) : const Color(0xFF78716C)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
