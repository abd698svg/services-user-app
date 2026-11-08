import 'package:flutter/material.dart';

class ClarificationScreen extends StatefulWidget {
  const ClarificationScreen({Key? key}) : super(key: key);

  @override
  State<ClarificationScreen> createState() => _ClarificationScreenState();
}

class _ClarificationScreenState extends State<ClarificationScreen> {
  // Toggle state: true = Clarification (State A), false = Manual Selection (State B)
  // In a real app, this is determined by the backend AI response.
  bool _isClarificationState = true;

  // State A: Clarification
  final List<String> _clarificationOptions = [
    'مشكلة في الأجهزة (Hardware)',
    'مشكلة في البرامج (Software)',
    'مشكلة في الشبكة أو الاتصال (Network)',
    'أخرى',
  ];
  String? _selectedClarificationOption;
  final TextEditingController _detailsController = TextEditingController();

  // State B: Manual Selection
  final List  _departments = [
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
  String? _selectedDepartment;

  bool _isLoading = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_isClarificationState && _selectedClarificationOption == null) {
      return; // Should be disabled anyway
    }
    if (!_isClarificationState && _selectedDepartment == null) {
      return; // Should be disabled anyway
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      // Proceed to S09 (AI Analysis) or C01 (Confirm)
      // Navigator.pushNamed(context, '/ai_analysis');
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
          title: Text(
            _isClarificationState ? 'توضيح إضافي' : 'اختيار القسم',
            style: const TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1917),
            ),
          ),
          centerTitle: true,
          actions: [
            // Demo toggle - remove in production
            TextButton(
              onPressed: () {
                setState(() {
                  _isClarificationState = !_isClarificationState;
                });
              },
              child: const Text(
                'تبديل',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 12,
                  color: Color(0xFFC2410C),
                ),
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(color: Color(0xFFF1E7DD), height: 1, thickness: 1),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isClarificationState) ...[
                  // STATE A: Clarification UI
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF7ED), // orange-50
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Color(0xFFF97316), // orange-500
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'نحتاج إلى مزيد من المعلومات',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1917),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'للتوجيه الصحيح، يرجى الإجابة على السؤال التالي:',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 14,
                      color: Color(0xFF57534E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ما هو نوع المشكلة التي تواجهها؟',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Clarification Options
                  ..._clarificationOptions.map((option) {
                    return _buildSelectableCard(
                      title: option,
                      isSelected: _selectedClarificationOption == option,
                      onTap: () {
                        setState(() {
                          _selectedClarificationOption = option;
                        });
                      },
                    );
                  }),
                  
                  const SizedBox(height: 24),
                  
                  // Additional Details
                  if (_selectedClarificationOption == 'أخرى' || _selectedClarificationOption != null) ...[
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 4,
                      minLines: 3,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        color: Color(0xFF1C1917),
                      ),
                      decoration: InputDecoration(
                        labelText: 'تفاصيل إضافية (اختياري)',
                        alignLabelWithHint: true,
                        hintText: 'يرجى كتابة أي تفاصيل إضافية قد تساعدنا في فهم طلبك بشكل أفضل.',
                        hintStyle: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14,
                          color: Color(0xFFA8A29E),
                        ),
                        labelStyle: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Color(0xFF78716C),
                        ),
                        floatingLabelStyle: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Color(0xFFF97316),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE7DDD2), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE7DDD2), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFF97316), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                ] else ...[
                  // STATE B: Manual Selection UI
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEF2F2), // error tint
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFDC2626), // error
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'تعذر تحديد القسم تلقائياً',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1917),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لم نتمكن من تحليل طلبك بشكل كافٍ لتحديد القسم المسؤول. يرجى اختيار القسم الأقرب لطبيعة طلبك يدوياً:',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF57534E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Department Options
                  ..._departments.map((dept) {
                    return _buildSelectableDepartmentCard(
                      title: dept['name'],
                      description: dept['description'],
                      icon: dept['icon'],
                      isSelected: _selectedDepartment == dept['name'],
                      onTap: () {
                        setState(() {
                          _selectedDepartment = dept['name'];
                        });
                      },
                    );
                  }),
                  
                  const SizedBox(height: 24),
                ],

                // Bottom Actions
                Row(
                  children: [
                    // Back Button
                    Expanded(
                      flex: 1,
                      child: Container(
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
                            onTap: _isLoading ? null : () => Navigator.pop(context),
                            child: const Center(
                              child: Text(
                                'رجوع',
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
                    ),
                    const SizedBox(width: 16),
                    // Continue Button
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (_isClarificationState && _selectedClarificationOption == null) || 
                                    (!_isClarificationState && _selectedDepartment == null)
                                ? [const Color(0xFFF5F0EA), const Color(0xFFF5F0EA)] // disabled-bg
                                : [const Color(0xFFF26B0F), const Color(0xFFD9480F)],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: ((_isClarificationState && _selectedClarificationOption != null) || 
                                    (!_isClarificationState && _selectedDepartment != null)) && !_isLoading
                                ? _handleContinue
                                : null,
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'متابعة',
                                      style: TextStyle(
                                        fontFamily: 'IBM Plex Sans Arabic',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: ((_isClarificationState && _selectedClarificationOption == null) || 
                                                (!_isClarificationState && _selectedDepartment == null))
                                            ? const Color(0xFFA8A29E) // disabled-text
                                            : Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : Colors.white, // orange-50
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFF97316) : const Color(0xFFF1E7DD), // orange-500 vs border-soft
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom Radio Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFF97316) : const Color(0xFFA8A29E),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF97316),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: const Color(0xFF1C1917),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableDepartmentCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFF97316) : const Color(0xFFF1E7DD),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEDD5), // orange-100
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFC2410C), size: 24),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: const Color(0xFF1C1917),
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
            const SizedBox(width: 12),
            // Custom Radio Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFF97316) : const Color(0xFFA8A29E),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF97316),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
