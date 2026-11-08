import 'package:flutter/material.dart';

class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  // Mock AI Analysis Data
  final Map<String, dynamic> aiData = {
    'type': 'Issue', // Issue, Service Request, Inquiry
    'suggested_department': 'IT Support',
    'category': 'الشبكات والاتصال',
    'priority': 'Medium', // Low, Medium, High
    'solution_available': true,
    'solution_steps': [
      'تأكد من تفعيل خاصية الواي فاي (Wi-Fi) في جهازك.',
      'اختر شبكة الجامعة (YPU-Student) من قائمة الشبكات المتاحة.',
      'قم بإدخال بيانات الدخول الخاصة بك (الرقم الجامعي وكلمة المرور).',
      'إذا استمرت المشكلة، يرجى محاولة إعادة تشغيل جهازك.',
    ],
    'source_title': 'دليل الاتصال بشبكة الجامعة - IT Support',
  };

  @override
  void initState() {
    super.initState();
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Simulate API Call for Analysis and RAG
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _simulateAiError() {
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
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
            'تحليل الطلب',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1917),
            ),
          ),
          centerTitle: true,
          actions: [
            // Demo toggle to simulate AI failure
            TextButton(
              onPressed: _simulateAiError,
              child: const Text(
                'محاكاة فشل AI',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 12,
                  color: Color(0xFFDC2626),
                ),
              ),
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
        bottomNavigationBar: (!_isLoading && !_hasError) ? _buildBottomActions() : null,
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Tag and Disclaimer
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED), // orange-50
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFFED7AA)), // orange-200
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.auto_awesome, size: 16, color: Color(0xFFF97316)),
                    SizedBox(width: 6),
                    Text(
                      'اقتراح الذكاء الاصطناعي',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9A3412), // orange-800
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'قد يحتوي على أخطاء، ويمكنك تعديله.',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 12,
              color: Color(0xFF78716C), // ink-muted
            ),
          ),
          const SizedBox(height: 24),

          // Request Analysis Card
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ملخص التحليل',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1917),
                  ),
                ),
                const SizedBox(height: 16),
                _buildAnalysisRow('نوع الطلب', _getTypeLabel(aiData['type'])),
                const SizedBox(height: 12),
                _buildAnalysisRow('الفئة', aiData['category']),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الأولوية',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 14,
                        color: Color(0xFF57534E),
                      ),
                    ),
                    _buildPriorityChip(aiData['priority']),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF1E7DD), height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'القسم المقترح',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 14,
                        color: Color(0xFF57534E),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED), // orange-50
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFFED7AA)), // orange-200
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business_outlined, size: 14, color: Color(0xFFC2410C)),
                          const SizedBox(width: 4),
                          Text(
                            aiData['suggested_department'],
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC2410C), // orange-700
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Suggested Solution Card (RAG)
          if (aiData['solution_available']) ...[
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0FDF4), // success tint
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFF16A34A), // success solid
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'الحل المقترح',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1917),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Steps
                  ...List.generate(aiData['solution_steps'].length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFEDD5), // orange-100
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFC2410C),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              aiData['solution_steps'][index],
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xFF57534E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Source Chip
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFF1E7DD)), // border-soft
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.description_outlined, size: 14, color: Color(0xFF78716C)),
                            const SizedBox(width: 6),
                            Text(
                              'المصدر: ${aiData['source_title']}',
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 12,
                                color: Color(0xFF57534E), // ink-secondary
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // Empty Knowledge Base State
            _buildSectionCard(
              child: Column(
                children: [
                  const Icon(Icons.menu_book_outlined, size: 48, color: Color(0xFFA8A29E)),
                  const SizedBox(height: 16),
                  const Text(
                    'لم نجد إرشادات مناسبة في قاعدة المعرفة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'لا تقلق، يمكنك المتابعة وإنشاء طلب وسيقوم الفريق المختص بمساعدتك.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 14,
                      color: Color(0xFF57534E),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          
          // Edit Request Button
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Navigate back to S07 (New Request)
                Navigator.pop(context);
              },
              icon: const Icon(Icons.edit_outlined, color: Color(0xFFC2410C), size: 20),
              label: const Text(
                'تعديل الطلب',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC2410C), // orange-700
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1E7DD), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1AC2410C), // elevation 2 shadow
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary Action: I Still Need Help
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF26B0F), Color(0xFFD9480F)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    // Navigate to C01 (Confirm Submission)
                    // Navigator.pushNamed(context, '/confirm_submission');
                  },
                  child: const Center(
                    child: Text(
                      'أحتاج إلى مساعدة إضافية',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Secondary Action: This Solved My Issue
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEA580C), width: 1.5), // orange-600
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    // Ends the help journey, navigate to Home
                    // Navigator.popUntil(context, ModalRoute.withName('/home'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إغلاق الطلب بنجاح. نتمنى لك يوماً سعيداً!')),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'تم حل مشكلتي',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC2410C), // orange-700
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildAnalysisRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 14,
            color: Color(0xFF57534E),
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

  String _getTypeLabel(String type) {
    switch (type) {
      case 'Issue': return 'مشكلة تقنية';
      case 'Service Request': return 'طلب خدمة';
      case 'Inquiry': return 'استفسار';
      default: return type;
    }
  }

  Widget _buildPriorityChip(String priority) {
    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case 'High':
        bgColor = const Color(0xFFFED7AA); // orange-200
        textColor = const Color(0xFF9A3412); // orange-800
        label = 'عالية';
        break;
      case 'Medium':
        bgColor = const Color(0xFFFFEDD5); // orange-100
        textColor = const Color(0xFF9A3412);
        label = 'متوسطة';
        break;
      case 'Low':
      default:
        bgColor = Colors.transparent;
        textColor = const Color(0xFFC2410C);
        label = 'منخفضة';
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

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
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
                color: Color(0xFFFEF2F2), // error tint
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 36,
                color: Color(0xFFDC2626), // error
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'تعذر إكمال التحليل الآلي',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1917),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'حدث انقطاع في الاتصال أو خطأ في خدمة الذكاء الاصطناعي. يمكنك اختيار القسم يدوياً للمتابعة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF57534E),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to S08 (Manual Department Selection)
                  // Navigator.pushNamed(context, '/clarification');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF26B0F),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text(
                  'اختيار القسم يدوياً',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _fetchAnalysis,
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
