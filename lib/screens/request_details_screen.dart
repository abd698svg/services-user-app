import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  // Mock Request Data
  final Map<String, dynamic> requestData = {
    'id': '1024',
    'title': 'مشكلة في الاتصال بشبكة الواي فاي في مبنى كلية الهندسة',
    'description': 'لا يمكنني الاتصال بشبكة الواي فاي الخاصة بالجامعة منذ صباح اليوم. حاولت إعادة تشغيل الجهاز وإعادة الاتصال لكن دون جدوى. الجهاز يعمل بشكل طبيعي على شبكات أخرى.',
    'location': 'مبنى كلية الهندسة - الطابق الثاني - مختبر 204',
    'date': '24 أكتوبر 2023, 10:30 صباحاً',
    'type': 'مشكلة تقنية',
    'category': 'الشبكات والاتصال',
    'suggested_department': 'IT Support',
    'current_department': 'IT Support',
    'status': 'In Progress',
    'priority': 'Medium',
    'last_updated': '24 أكتوبر 2023, 11:45 صباحاً',
    'attachment': 'صورة_الشاشة.jpg',
    'timeline': [
      {
        'title': 'تم استلام الطلب',
        'detail': 'تم تسجيل طلبك بنجاح في النظام.',
        'date': '24 أكتوبر 2023, 10:30 ص',
        'is_latest': false,
        'is_redirect': false,
      },
      {
        'title': 'قيد المراجعة',
        'detail': 'يقوم فريق الدعم الفني بمراجعة الطلب.',
        'date': '24 أكتوبر 2023, 10:45 ص',
        'is_latest': false,
        'is_redirect': false,
      },
      {
        'title': 'تم التحويل',
        'detail': 'من القسم: الدعم الفني العام ← إلى القسم: شبكات الحاسوب',
        'date': '24 أكتوبر 2023, 11:00 ص',
        'is_latest': false,
        'is_redirect': true,
        'reason': 'الطلب يتطلب تدخل متخصص شبكات.',
      },
      {
        'title': 'قيد التنفيذ',
        'detail': 'جاري العمل على حل المشكلة من قبل الفريق المختص.',
        'date': '24 أكتوبر 2023, 11:45 ص',
        'is_latest': true,
        'is_redirect': false,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchRequestDetails();
  }

  Future<void> _fetchRequestDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        // Uncomment to test error state (e.g., 403 Forbidden)
        // _hasError = true; 
      });
    }
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1917)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1917),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF1C1917)),
              onPressed: _fetchRequestDetails,
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(color: Color(0xFFF1E7DD), height: 1, thickness: 1),
          ),
        ),
        body: _isLoading
            ? _buildLoadingState()
            : _hasError
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Request Information
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${requestData['id']}',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                    _buildPriorityChip(requestData['priority']),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  requestData['title'],
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF1E7DD), height: 1),
                const SizedBox(height: 16),
                Text(
                  requestData['description'],
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF57534E),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on_outlined, requestData['location']),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.calendar_today_outlined, requestData['date']),
                if (requestData['attachment'] != null) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attachment, size: 18, color: Color(0xFFC2410C)),
                          const SizedBox(width: 8),
                          Text(
                            requestData['attachment'],
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 14,
                              color: Color(0xFFC2410C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Classification Information
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معلومات التصنيف',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
                const SizedBox(height: 12),
                _buildClassificationRow('نوع الطلب', requestData['type']),
                const SizedBox(height: 8),
                _buildClassificationRow('الفئة', requestData['category']),
                const SizedBox(height: 12),
                // AI Suggestion Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 16, color: Color(0xFFF97316)),
                      const SizedBox(width: 6),
                      Text(
                        'اقتراح الذكاء الاصطناعي: ${requestData['suggested_department']}',
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9A3412),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Current State
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الحالة الحالية',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(requestData['status']),
                    Text(
                      'آخر تحديث: ${requestData['last_updated']}',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 12,
                        color: Color(0xFF78716C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.business_outlined, 'القسم المسؤول: ${requestData['current_department']}'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Request Timeline
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'سجل الطلب',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTimeline(),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF78716C)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 14,
              color: Color(0xFF57534E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassificationRow(String label, String value) {
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

  Widget _buildPriorityChip(String priority) {
    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case 'High':
        bgColor = const Color(0xFFFED7AA); // orange-200
        textColor = const Color(0xFF9A3412); // orange-800
        label = 'أولوية عالية';
        break;
      case 'Medium':
        bgColor = const Color(0xFFFFEDD5); // orange-100
        textColor = const Color(0xFF9A3412);
        label = 'أولوية متوسطة';
        break;
      case 'Low':
      default:
        bgColor = Colors.transparent;
        textColor = const Color(0xFFC2410C);
        label = 'أولوية منخفضة';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: priority == 'Low' ? const Color(0xFFFDBA74) : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          fontSize: 12,
          fontWeight: priority == 'High' ? FontWeight.w700 : FontWeight.w500,
          color: textColor,
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
    bool isGradient = false;

    switch (status) {
      case 'New':
        bgColor = Colors.white;
        textColor = const Color(0xFFC2410C);
        borderColor = const Color(0xFFFDBA74);
        icon = Icons.fiber_new;
        label = 'جديد';
        break;
      case 'Under Review':
        bgColor = const Color(0xFFFFEDD5);
        textColor = const Color(0xFF9A3412);
        borderColor = Colors.transparent;
        icon = Icons.visibility;
        label = 'قيد المراجعة';
        break;
      case 'In Progress':
        isGradient = true;
        bgColor = Colors.transparent;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        icon = Icons.autorenew;
        label = 'قيد التنفيذ';
        break;
      case 'Resolved':
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF166534);
        borderColor = Colors.transparent;
        icon = Icons.check_circle;
        label = 'تم الحل';
        break;
      case 'Closed':
      default:
        bgColor = const Color(0xFFF5F0EA);
        textColor = const Color(0xFF57534E);
        borderColor = Colors.transparent;
        icon = Icons.lock;
        label = 'مغلق';
        break;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: textColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );

    if (isGradient) {
      return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF26B0F), Color(0xFFD9480F)],
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(child: content),
      );
    }

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
      ),
      child: Center(child: content),
    );
  }

  Widget _buildTimeline() {
    final List<dynamic> timeline = requestData['timeline'];
    return Column(
      children: List.generate(timeline.length, (index) {
        final event = timeline[index];
        final isLast = index == timeline.length - 1;
        final isLatest = event['is_latest'] == true;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline indicator (Dot + Line)
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    // Dot
                    Container(
                      width: isLatest ? 24 : 16,
                      height: isLatest ? 24 : 16,
                      margin: EdgeInsets.only(top: isLatest ? 0 : 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isLatest
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFF26B0F), Color(0xFFD9480F)],
                              )
                            : null,
                        color: isLatest ? null : const Color(0xFFF97316),
                      ),
                    ),
                    // Connecting Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: const Color(0xFFFED7AA),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Event Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0, top: isLatest ? 0 : 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 16,
                          fontWeight: isLatest ? FontWeight.w700 : FontWeight.w600,
                          color: isLatest ? const Color(0xFF1C1917) : const Color(0xFF57534E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (event['is_redirect'] == true) ...[
                        Row(
                          children: [
                            const Icon(Icons.swap_horiz, size: 16, color: Color(0xFFC2410C)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event['detail'],
                                style: const TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFC2410C),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (event['reason'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'السبب: ${event['reason']}',
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF78716C),
                            ),
                          ),
                        ],
                      ] else ...[
                        Text(
                          event['detail'],
                          style: const TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 14,
                            color: Color(0xFF57534E),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        event['date'],
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF78716C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 36,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'تعذر تحميل تفاصيل الطلب',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1917),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ليس لديك صلاحية للوصول إلى هذا الطلب أو حدث خطأ في الاتصال.',
              textAlign: TextAlign.center,
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
                onPressed: _fetchRequestDetails,
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
    );
  }
}
