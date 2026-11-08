import 'package:flutter/material.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({Key? key}) : super(key: key);

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Active, 2: Completed
  bool _isLoading = true;
  bool _hasError = false;

  // Mock Data representing API response
  final List  _allRequests = [
    {
      'id': '1024',
      'title': 'مشكلة في الاتصال بشبكة الواي فاي في مبنى كلية الهندسة',
      'department': 'IT Support',
      'status': 'In Progress', // New, Under Review, In Progress, Resolved, Closed
      'date': '24 أكتوبر 2023',
    },
    {
      'id': '1023',
      'title': 'طلب صيانة مكيف الهواء في قاعة المحاضرات 204',
      'department': 'Maintenance & Facilities',
      'status': 'Under Review',
      'date': '23 أكتوبر 2023',
    },
    {
      'id': '1015',
      'title': 'استفسار حول إجراءات تأجيل الفصل الدراسي',
      'department': 'Student Affairs',
      'status': 'Resolved',
      'date': '15 أكتوبر 2023',
    },
    {
      'id': '1009',
      'title': 'عدم القدرة على الدخول إلى البوابة الأكاديمية',
      'department': 'IT Support',
      'status': 'Closed',
      'date': '10 أكتوبر 2023',
    },
    {
      'id': '1002',
      'title': 'الإبلاغ عن تسرب مياه في دورة مياه المبنى الرئيسي',
      'department': 'Maintenance & Facilities',
      'status': 'New',
      'date': '05 أكتوبر 2023',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Simulate Network Request
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        // _hasError = true; // Uncomment to test error state
      });
    }
  }

  List  get _filteredRequests {
    if (_selectedFilter == 1) {
      // Active: Not Resolved, Not Closed
      return _allRequests
          .where((req) => req['status'] != 'Resolved' && req['status'] != 'Closed')
          .toList();
    } else if (_selectedFilter == 2) {
      // Completed: Resolved, Closed
      return _allRequests
          .where((req) => req['status'] == 'Resolved' || req['status'] == 'Closed')
          .toList();
    }
    return _allRequests;
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
            'طلباتي',
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
        body: Column(
          children: [
            // Filter Tabs
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  _buildFilterTab('الكل', 0),
                  const SizedBox(width: 12),
                  _buildFilterTab('نشط', 1),
                  const SizedBox(width: 12),
                  _buildFilterTab('مكتمل', 2),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchRequests,
                color: const Color(0xFFF97316),
                child: _isLoading
                    ? _buildSkeletonList()
                    : _hasError
                        ? _buildErrorState()
                        : _filteredRequests.isEmpty
                            ? _buildEmptyState()
                            : _buildRequestList(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const _CustomBottomNavBar(activeTabIndex: 1),
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFEDD5) : Colors.white, // orange-100 vs white
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFF1E7DD),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF9A3412) : const Color(0xFF57534E), // orange-800 vs ink-secondary
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _filteredRequests.length,
      itemBuilder: (context, index) {
        final request = _filteredRequests[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildRequestCard(request),
        );
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return InkWell(
      onTap: () {
        // Navigate to S06 - Request Details
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
          children: [
            // Top Row: Request ID and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${request['id']}',
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFC2410C), // orange-700
                  ),
                ),
                _buildStatusBadge(request['status']),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              request['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1917), // ink
              ),
            ),
            const SizedBox(height: 16),

            // Bottom Row: Department Chip and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Department Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED), // orange-50
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFED7AA)), // orange-200
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.business_outlined,
                        size: 14,
                        color: Color(0xFFC2410C), // orange-700
                      ),
                      const SizedBox(width: 4),
                      Text(
                        request['department'],
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFC2410C),
                        ),
                      ),
                    ],
                  ),
                ),
                // Date
                Text(
                  request['date'],
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF78716C), // ink-muted
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    Color? borderColor;
    IconData icon;
    String label;

    switch (status) {
      case 'New':
        bgColor = Colors.white;
        textColor = const Color(0xFFC2410C); // orange-700
        borderColor = const Color(0xFFFDBA74); // orange-300
        icon = Icons.fiber_new;
        label = 'جديد';
        break;
      case 'Under Review':
        bgColor = const Color(0xFFFFEDD5); // orange-100
        textColor = const Color(0xFF9A3412); // orange-800
        borderColor = Colors.transparent;
        icon = Icons.visibility;
        label = 'قيد المراجعة';
        break;
      case 'In Progress':
        bgColor = Colors.transparent; // Handled by gradient
        textColor = Colors.white;
        borderColor = Colors.transparent;
        icon = Icons.autorenew;
        label = 'قيد التنفيذ';
        break;
      case 'Resolved':
        bgColor = const Color(0xFFF0FDF4); // success tint
        textColor = const Color(0xFF166534); // success text
        borderColor = Colors.transparent;
        icon = Icons.check_circle;
        label = 'تم الحل';
        break;
      case 'Closed':
      default:
        bgColor = const Color(0xFFF5F0EA); // disabled-bg
        textColor = const Color(0xFF57534E); // ink-secondary
        borderColor = Colors.transparent;
        icon = Icons.lock;
        label = 'مغلق';
        break;
    }

    Widget badgeContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );

    if (status == 'In Progress') {
      return Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF26B0F), Color(0xFFD9480F)],
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(child: badgeContent),
      );
    }

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
      ),
      child: Center(child: badgeContent),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 152,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED), // orange-50
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 40, height: 16, color: Colors.white),
                    Container(width: 80, height: 28, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                Container(width: double.infinity, height: 20, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: 200, height: 20, color: Colors.white),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 100, height: 24, color: Colors.white),
                    Container(width: 60, height: 16, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_open_rounded,
                  size: 48,
                  color: Color(0xFFFDBA74), // orange-300
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'لا توجد طلبات',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'لم تقم بإنشاء أي طلبات في هذه الفئة بعد.',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 14,
                  color: Color(0xFF57534E),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to S07 (New Request)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26B0F),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: const Text(
                    'إنشاء طلب جديد',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2), // error tint
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 36,
                  color: Color(0xFFDC2626), // error solid
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'فشل تحميل الطلبات',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'حدث خطأ في الاتصال بالخادم. يرجى المحاولة مرة أخرى.',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 14,
                  color: Color(0xFF57534E),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 160,
                height: 52,
                child: OutlinedButton(
                  onPressed: _fetchRequests,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC2410C), width: 1.5),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC2410C),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

