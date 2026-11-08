import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Mock Initial Data
  final String _initialName = 'أحمد محمد';
  final String _studentId = '20231234';
  final String _email = 'student@ypu.edu.sy';

  late TextEditingController _nameController;
  
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _initialName);
    // Listen to changes to update the UI for the unsaved changes indicator if needed
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasUnsavedChanges => _nameController.text.trim() != _initialName;

  Future<void> _handleSave() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    // Mock Network Error (Toggle for demonstration)
    bool isNetworkError = false; 

    if (isNetworkError) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      // Return to Profile (S10) with success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الاسم بنجاح'),
          backgroundColor: Color(0xFF16A34A), // success solid
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      barrierColor: const Color(0x731C1917), // scrim
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
                    'تغييرات غير محفوظة',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'لديك تغييرات غير محفوظة. هل أنت متأكد من رغبتك في المغادرة وتجاهلها؟',
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
                      // Discard Button (Secondary/Error)
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFDC2626), width: 1.5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Leave screen
                              },
                              child: const Center(
                                child: Text(
                                  'تجاهل التعديلات',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Keep Editing Button (Primary)
                      Expanded(
                        child: Container(
                          height: 48,
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
                              onTap: () => Navigator.pop(context),
                              child: const Center(
                                child: Text(
                                  'متابعة التعديل',
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
    // PopScope intercepts back gesture/button
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _hasUnsavedChanges) {
          _showDiscardDialog();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFBF7),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1917)),
              onPressed: () {
                if (_hasUnsavedChanges) {
                  _showDiscardDialog();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: const Text(
              'تعديل الاسم',
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
                      'معلومات الحساب',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1917),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'يمكنك تعديل اسمك الكامل أدناه. لا يمكن تغيير الرقم الجامعي أو البريد الإلكتروني من هذه الواجهة.',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF57534E),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Editable Name Field
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        color: Color(0xFF1C1917),
                      ),
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل',
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
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF78716C)),
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
                          return 'الرجاء إدخال الاسم الكامل';
                        }
                        if (value.trim().length > 100) {
                          return 'الاسم طويل جداً. يجب أن لا يتجاوز 100 حرف.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Read-only Student ID Field
                    _buildReadOnlyField(
                      label: 'الرقم الجامعي',
                      value: _studentId,
                    ),
                    const SizedBox(height: 16),

                    // Read-only Email Field
                    _buildReadOnlyField(
                      label: 'البريد الإلكتروني',
                      value: _email,
                    ),
                    const SizedBox(height: 24),

                    // Inline Error Banner
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
          
          // Sticky Bottom Bar
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20.0),
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
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Cancel Button
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEA580C), width: 1.5),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _isSaving
                              ? null
                              : () {
                                  if (_hasUnsavedChanges) {
                                    _showDiscardDialog();
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                          child: const Center(
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC2410C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Save Button
                  Expanded(
                    flex: 2,
                    child: Container(
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
                          onTap: _isSaving || !_hasUnsavedChanges ? null : _handleSave,
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'حفظ التغييرات',
                                    style: TextStyle(
                                      fontFamily: 'IBM Plex Sans Arabic',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: !_hasUnsavedChanges
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF78716C), // ink-muted
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EA), // disabled-bg
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 16,
                  color: Color(0xFFA8A29E), // disabled-text
                ),
              ),
              const Icon(
                Icons.lock_outline,
                size: 20,
                color: Color(0xFFA8A29E),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
