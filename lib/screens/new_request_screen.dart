import 'package:flutter/material.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({Key? key}) : super(key: key);

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _hasImage = false; // Mock state for image attachment

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate sending data to Laravel for Draft/Analysis
    await Future.delayed(const Duration(seconds: 2));

    // Mock Backend Validation Error (e.g., description too short)
    if (_descriptionController.text.trim().length < 15) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'الوصف قصير جداً. يرجى تقديم المزيد من التفاصيل لتتمكن المساعدة بشكل أفضل.';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      // Navigate to S08: Clarification & Manual Department Selection (or S09 if AI succeeds)
      // Navigator.pushNamed(context, '/clarification');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري تحليل الطلب...')),
      );
    }
  }

  void _mockPickImage() {
    // In a real app, use image_picker package here
    setState(() {
      _hasImage = true;
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
            'طلب جديد',
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'صف مشكلتك أو استفسارك',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سيساعدك فريقنا في توجيه طلبك إلى القسم المختص. يرجى تقديم أكبر قدر من التفاصيل.',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF57534E),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title Field
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      color: Color(0xFF1C1917),
                    ),
                    decoration: InputDecoration(
                      labelText: 'عنوان الطلب',
                      hintText: 'مثال: مشكلة في الاتصال بالشبكة',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال عنوان الطلب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    minLines: 4,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      color: Color(0xFF1C1917),
                    ),
                    decoration: InputDecoration(
                      labelText: 'وصف المشكلة أو الاستفسار',
                      alignLabelWithHint: true,
                      hintText: 'يرجى وصف ما حدث، ومتى بدأ، وأين يقع المكان. كلما زادت التفاصيل، كان التوجيه أدق.',
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال وصف للمشكلة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // Helper Text regarding AI
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, size: 14, color: Color(0xFFF97316)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'سيقترح الذكاء الاصطناعي القسم المناسب بناءً على وصفك.',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 12,
                            color: Color(0xFF78716C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location Field
                  TextFormField(
                    controller: _locationController,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 16,
                      color: Color(0xFF1C1917),
                    ),
                    decoration: InputDecoration(
                      labelText: 'الموقع (اختياري)',
                      hintText: 'مثال: مبنى كلية الهندسة، الطابق الثاني، مختبر 204',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF78716C)),
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

                  // Attachment Section
                  const Text(
                    'إرفاق صورة (اختياري)',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (!_hasImage)
                    GestureDetector(
                      onTap: _mockPickImage,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED), // orange-50
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFFED7AA), // orange-200
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate_outlined, size: 32, color: Color(0xFFC2410C)),
                            SizedBox(height: 8),
                            Text(
                              'اضغط لاختيار صورة من جهازك',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 14,
                                color: Color(0xFFC2410C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF1E7DD)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0EA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.image, color: Color(0xFFA8A29E)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'صورة_الشاشة.jpg',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 14,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
                            onPressed: () {
                              setState(() {
                                _hasImage = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 32),

                  // Form-level Error Banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFDC2626),
                            size: 20,
                          ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Continue Button
                  Container(
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
                        onTap: _isLoading ? null : _handleContinue,
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
                              : const Text(
                                  'متابعة',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 16,
                                    height: 22 / 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
