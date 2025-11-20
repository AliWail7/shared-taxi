import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../models/vehicle.dart';

class RegisterScreen extends StatefulWidget {
  final bool isDriver;
  
  const RegisterScreen({super.key, required this.isDriver});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Driver specific fields
  final _vehicleBrandController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _governorateController = TextEditingController();
  
  VehicleType? _selectedVehicleType;
  int _totalSeats = 4;
  bool _hasAC = true;
  bool _isLoading = false;
  bool _acceptedTerms = false;
  
  // Vehicle images
  String? _frontImagePath;
  String? _backImagePath;
  String? _sideImagePath;
  String? _interiorImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleBrandController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _plateNumberController.dispose();
    _addressController.dispose();
    _governorateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Text(
          widget.isDriver ? 'تسجيل حساب سائق' : 'تسجيل حساب راكب',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        border: null,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        widget.isDriver ? CupertinoIcons.car_fill : CupertinoIcons.person_2_fill,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isDriver ? 'انضم كسائق' : 'انضم كراكب',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isDriver
                            ? 'ابدأ بكسب المال من خلال مشاركة رحلاتك'
                            : 'احجز رحلاتك بسهولة وأمان',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Personal Information Section
                const Text(
                  'المعلومات الشخصية',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Full Name
                CustomTextField(
                  controller: _nameController,
                  labelText: 'الاسم الكامل',
                  hintText: 'أدخل اسمك الكامل',
                  prefixIcon: const Icon(CupertinoIcons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الاسم';
                    }
                    if (value.length < 3) {
                      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Phone Number
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  hintText: '07XX XXX XXXX',
                  prefixIcon: const Icon(CupertinoIcons.phone),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    if (value.length < 11) {
                      return 'رقم الهاتف يجب أن يكون 11 رقم';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Email (Optional)
                CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني (اختياري)',
                  hintText: 'example@email.com',
                  prefixIcon: const Icon(CupertinoIcons.mail),
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 16),
                
                // Governorate
                CustomTextField(
                  controller: _governorateController,
                  labelText: 'المحافظة',
                  hintText: 'مثال: بغداد، البصرة، أربيل',
                  prefixIcon: const Icon(CupertinoIcons.map_pin_ellipse),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال المحافظة';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Password
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  hintText: 'أدخل كلمة المرور',
                  prefixIcon: const Icon(CupertinoIcons.lock),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  hintText: 'أعد إدخال كلمة المرور',
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                
                if (widget.isDriver) ...[
                  const SizedBox(height: 16),
                  
                  // Address (Driver only)
                  CustomTextField(
                    controller: _addressController,
                    labelText: 'عنوان السكن',
                    hintText: 'مثال: حي الجامعة، شارع الرباط',
                    prefixIcon: const Icon(CupertinoIcons.location_solid),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال عنوان السكن';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Vehicle Information Section
                  const Text(
                    'معلومات المركبة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Vehicle Type
                  _buildVehicleTypeSelector(),
                  
                  const SizedBox(height: 16),
                  
                  // Vehicle Brand
                  CustomTextField(
                    controller: _vehicleBrandController,
                    labelText: 'نوع المركبة',
                    hintText: 'مثال: تويوتا، كيا، هونداي',
                    prefixIcon: const Icon(CupertinoIcons.car_detailed),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال نوع المركبة';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Vehicle Model
                  CustomTextField(
                    controller: _vehicleModelController,
                    labelText: 'موديل المركبة',
                    hintText: 'مثال: كامري، سيراتو، النترا',
                    prefixIcon: const Icon(CupertinoIcons.car),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الموديل';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Vehicle Color
                  CustomTextField(
                    controller: _vehicleColorController,
                    labelText: 'لون المركبة',
                    hintText: 'مثال: أبيض، أسود، فضي',
                    prefixIcon: const Icon(CupertinoIcons.color_filter),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اللون';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Plate Number
                  CustomTextField(
                    controller: _plateNumberController,
                    labelText: 'رقم اللوحة',
                    hintText: 'مثال: بغداد 12345',
                    prefixIcon: const Icon(CupertinoIcons.number),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم اللوحة';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Total Seats
                  _buildSeatsSelector(),
                  
                  const SizedBox(height: 16),
                  
                  // Has AC
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.wind_snow,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'يوجد تكييف',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch(
                            value: _hasAC,
                            onChanged: (value) => setState(() => _hasAC = value),
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Vehicle Images Section
                  const Text(
                    'صور المركبة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يرجى إضافة صور واضحة للمركبة من جميع الجهات',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Front Image
                  _buildImagePicker(
                    'صورة المركبة من الأمام',
                    CupertinoIcons.car_detailed,
                    _frontImagePath,
                    () => _pickImage('front'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Back Image
                  _buildImagePicker(
                    'صورة المركبة من الخلف',
                    CupertinoIcons.car_detailed,
                    _backImagePath,
                    () => _pickImage('back'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Side Image
                  _buildImagePicker(
                    'صورة المركبة من الجانب',
                    CupertinoIcons.car_detailed,
                    _sideImagePath,
                    () => _pickImage('side'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Interior Image
                  _buildImagePicker(
                    'صورة من داخل المركبة',
                    CupertinoIcons.photo_camera,
                    _interiorImagePath,
                    () => _pickImage('interior'),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Terms and Conditions
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const Expanded(
                          child: Text(
                            'أوافق على الشروط والأحكام وسياسة الخصوصية',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Register Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _acceptedTerms ? _register : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: _acceptedTerms
                            ? const LinearGradient(
                                colors: [AppColors.secondary, AppColors.secondary],
                              )
                            : null,
                        color: _acceptedTerms ? null : AppColors.border,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _acceptedTerms
                            ? [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CupertinoActivityIndicator(color: AppColors.primary),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.checkmark_circle_fill,
                                  color: _acceptedTerms ? AppColors.primary : AppColors.textHint,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'إنشاء الحساب',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _acceptedTerms ? AppColors.primary : AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(CupertinoIcons.car_detailed, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'صنف المركبة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: VehicleType.values.map((type) {
              final isSelected = _selectedVehicleType == type;
              String typeName;
              IconData typeIcon;
              
              switch (type) {
                case VehicleType.sedan:
                  typeName = 'سيدان';
                  typeIcon = CupertinoIcons.car_fill;
                  break;
                case VehicleType.suv:
                  typeName = 'دفع رباعي';
                  typeIcon = CupertinoIcons.car_detailed;
                  break;
                case VehicleType.van:
                  typeName = 'فان';
                  typeIcon = CupertinoIcons.bus;
                  break;
                case VehicleType.minibus:
                  typeName = 'باص صغير';
                  typeIcon = CupertinoIcons.bus;
                  break;
              }
              
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedVehicleType = type),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          typeIcon,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          typeName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatsSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(CupertinoIcons.person_2_fill, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'إجمالي عدد المقاعد',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: _totalSeats > 2 ? () => setState(() => _totalSeats--) : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _totalSeats > 2 ? AppColors.primary : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.minus, color: Colors.white, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_totalSeats',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: _totalSeats < 15 ? () => setState(() => _totalSeats++) : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _totalSeats < 15 ? AppColors.primary : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.plus, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.isDriver && _selectedVehicleType == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('تنبيه'),
          content: const Text('الرجاء اختيار صنف المركبة'),
          actions: [
            CupertinoDialogAction(
              child: const Text('حسناً'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('نجاح'),
          content: Text(
            widget.isDriver
                ? 'تم إنشاء حسابك بنجاح!\nسيتم مراجعة بياناتك خلال 24 ساعة.'
                : 'تم إنشاء حسابك بنجاح!\nيمكنك الآن البدء بحجز الرحلات.',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('متابعة'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      );
    }
  }
  
  Widget _buildImagePicker(String label, IconData icon, String? imagePath, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: imagePath != null ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: imagePath != null ? AppColors.primary : AppColors.border,
              width: imagePath != null ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: imagePath != null ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: imagePath != null ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    if (imagePath != null)
                      const Text(
                        'تم اختيار الصورة ✓',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                imagePath != null ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.camera,
                color: imagePath != null ? AppColors.success : AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _pickImage(String imageType) async {
    // Show image source selection dialog
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('اختر مصدر الصورة'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _selectImageFromCamera(imageType);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.camera, color: AppColors.primary),
                SizedBox(width: 8),
                Text('التقاط صورة'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _selectImageFromGallery(imageType);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.photo, color: AppColors.primary),
                SizedBox(width: 8),
                Text('اختيار من المعرض'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: const Text('إلغاء'),
        ),
      ),
    );
  }
  
  Future<void> _selectImageFromCamera(String imageType) async {
    // Simulate camera selection
    // In real app, use image_picker package
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      switch (imageType) {
        case 'front':
          _frontImagePath = 'camera_front_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
        case 'back':
          _backImagePath = 'camera_back_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
        case 'side':
          _sideImagePath = 'camera_side_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
        case 'interior':
          _interiorImagePath = 'camera_interior_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
      }
    });
  }
  
  Future<void> _selectImageFromGallery(String imageType) async {
    // Simulate gallery selection
    // In real app, use image_picker package
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      switch (imageType) {
        case 'front':
          _frontImagePath = 'gallery_front_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
        case 'back':
          _backImagePath = 'gallery_back_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
        case 'side':
          _sideImagePath = 'gallery_side_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
        case 'interior':
          _interiorImagePath = 'gallery_interior_${DateTime.now().millisecondsSinceEpoch}.jpg';
          break;
      }
    });
  }
}
