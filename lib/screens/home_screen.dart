import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String studentName = 'أحمد';
  
  final List  announcements = [
    {
      'title': 'بدء التسجيل للفصل الدراسي القادم',
      'summary': 'نود إعلامكم ببدء فترة التسجيل للفصل الدراسي الربيعي ابتداءً من الأسبوع القادم. يرجى مراجعة موقع الجامعة.',
      'date': '15 أكتوبر 2023',
      'isActive': true,
    },
    {
      'title': 'صيانة مجدولة لخدمات تكنولوجيا المعلومات',
      'summary': 'ستقوم إدارة الدعم الفني بإجراء صيانة دورية للأنظمة يوم الجمعة القادم من الساعة 10 مساءً حتى 2 صباحاً.',
      'date': '10 أكتوبر 2023',
      'isActive': true,
    },
  ];

  final List  services = [
    {
      'name': 'IT Support',
      'description': 'الدعم الفني، مشاكل الشبكة، والصيانة التقنية.',
      'icon': Icons.computer_rounded,
    },
    {
      'name': 'Maintenance & Facilities',
      'description': 'صيانة المرافق، الأعطال الكهربائية، والنظافة.',
      'icon': Icons.build_rounded,
    },
    {
      'name': 'Student Affairs',
      'description': 'الاستفسارات الأكاديمية، وثائق التخرج، وشؤون الطلاب.',
      'icon': Icons.school_rounded,
    },
  ];

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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF26B0F), Color(0xFFD9480F)],
                  ),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Smart Service Request',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1917),
                ),
              ),
            ],
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(color: Color(0xFFF1E7DD), height: 1, thickness: 1),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFF7ED),
                        Color(0xFFFFEDD5),
                        Color(0xFFFED7AA),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFF97316),
                            child: Text(
                              studentName.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'مرحباً، $studentName',
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'قدم مشكلتك أو استفسارك واحصل على مساعدة أولية وتابع الطلب من مكان واحد.',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF57534E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Announcements Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الإعلانات',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1917),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC2410C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // Announcements List
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final ann = announcements[index];
                    final bool isActive = ann['isActive'] as bool;
                    final String date = ann['date'] as String;
                    final String title = ann['title'] as String;
                    final String summary = ann['summary'] as String;

                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(left: 16.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1E7DD)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F7C2D12),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isActive ? const Color(0xFFF0FDF4) : const Color(0xFFF5F0EA),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  isActive ? 'نشط' : 'منتهي',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isActive ? const Color(0xFF166534) : const Color(0xFF57534E),
                                  ),
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: 12,
                                  color: Color(0xFF78716C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1917),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 14,
                                height: 1.4,
                                color: Color(0xFF57534E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Our Services Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'خدماتنا',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: services.map((service) {
                    final String name = service['name'] as String;
                    final String description = service['description'] as String;
                    final IconData icon = service['icon'] as IconData;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1E7DD)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFEDD5),
                            ),
                            child: Icon(
                              icon,
                              color: const Color(0xFFC2410C),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1C1917),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 14,
                                    color: Color(0xFF78716C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // How It Works Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'كيف يعمل؟',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1E7DD)),
                  ),
                  child: Column(
                    children: [
                      _buildStepItem(1, 'صف طلبك', 'اشرح مشكلتك أو استفسارك بوضوح.'),
                      _buildStepDivider(),
                      _buildStepItem(2, 'احصل على مساعدة AI', 'سيقوم النظام بتوجيهك للقسم المناسب.'),
                      _buildStepDivider(),
                      _buildStepItem(3, 'تابع طلبك', 'ابقَ على اطلاع بحالة طلبك في أي وقت.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        bottomNavigationBar: const _CustomBottomNavBar(activeTabIndex: 0),
      ),
    );
  }

  Widget _buildStepItem(int number, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFFEDD5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.bold,
                color: Color(0xFFC2410C),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 14,
                  color: Color(0xFF57534E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 4, bottom: 4),
      child: Container(
        height: 24,
        width: 2,
        color: const Color(0xFFFFEDD5),
      ),
    );
  }
}

// Bottom Navigation Bar with Integrated Add Button and Fully Functional Navigation
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
            // Home Tab
            _buildNavItem(
              context: context,
              icon: Icons.home,
              label: 'الرئيسية',
              isActive: activeTabIndex == 0,
              onTap: () {
                if (activeTabIndex != 0) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // If already on Home, scroll to top or refresh behavior
                  Scrollable.ensureVisible(
                    context,
                    alignment: 0,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              },
            ),
            // My Requests Tab
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
            // Add New Request Tab (Integrated inside the bottom bar)
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
            // Profile Tab
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
