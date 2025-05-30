import 'package:arean/auth/cubit/Registercubit.dart';
import 'package:arean/auth/state/Registerstate.dart';
import 'package:arean/constant/colors.dart';
import 'package:arean/auth/secrees/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// Enhanced Color Constants
const LightBlue = Color(0xFF7DD3FC);
var PrimaryColor = Blue;

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final phone_number = TextEditingController();
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  int _currentStep = 0;

  late AnimationController _heroController;
  late AnimationController _formController;
  late AnimationController _stepController;

  late Animation<double> _heroAnimation;
  late Animation<double> _formAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _stepController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutBack,
    );

    _formAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(_formAnimation);
  }

  void _startAnimations() {
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _formController.dispose();
    _stepController.dispose();
    phone_number.dispose();
    first_name.dispose();
    last_name.dispose();
    password.dispose();
    confirm_password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SuccessState) {
          _showSuccessAnimation();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'مرحباً بك!',
            text: 'تم إنشاء حسابك بنجاح',
            confirmBtnColor: Orange,
            confirmBtnText: 'تسجيل الدخول',
            onConfirmBtnTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          );
        }

        if (state is FieldState) {
          HapticFeedback.vibrate();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'خطأ في التسجيل',
            text: state.message,
            confirmBtnColor: Orange,
            confirmBtnText: 'حسناً',
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Container(
              decoration: _buildBackgroundGradient(),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    child: Column(
                      children: [
                        // Enhanced Hero Section
                        Expanded(
                          flex: 1,
                          child: _buildHeroSection(),
                        ),

                        // Modern Registration Form
                        Expanded(
                          flex: 4,
                          child: _buildRegistrationForm(state, cubit),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildBackgroundGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.4, 0.8, 1.0],
        colors: [
          Blue.withOpacity(0.9),
          Blue.withOpacity(0.6),
          LightBlue.withOpacity(0.2),
          Colors.white,
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _heroAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Medical Registration Logo
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.9)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Orange, Orange.withOpacity(0.8)],
                      ),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "انضم إلى منصتنا الطبية",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegistrationForm(AuthState state, AuthCubit cubit) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(),
              const SizedBox(height: 24),
              _buildProgressIndicator(),
              const SizedBox(height: 28),
              Expanded(child: _buildForm(state, cubit)),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Orange, Blue]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "بياناتك الشخصية",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "أدخل معلوماتك لإنشاء حساب آمن",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle, color: Blue, size: 18),
          const SizedBox(width: 8),
          const Text(
            "خطوة 1 من 1",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const Spacer(),
          Text(
            "معلومات أساسية",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AuthState state, AuthCubit cubit) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name Fields Row
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: first_name,
                  label: "الاسم الأول",
                  hint: "أحمد",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم الأول';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernTextField(
                  controller: last_name,
                  label: "الاسم الأخير",
                  hint: "محمد",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم الأخير';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Phone Field
          _buildModernTextField(
            controller: phone_number,
            label: "رقم الهاتف",
            hint: "+966 5X XXX XXXX",
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          // Password Field
          _buildModernTextField(
            controller: password,
            label: "كلمة المرور",
            hint: "أدخل كلمة مرور قوية",
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onPasswordToggle: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          // Confirm Password Field
          _buildModernTextField(
            controller: confirm_password,
            label: "تأكيد كلمة المرور",
            hint: "أعد إدخال كلمة المرور",
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onPasswordToggle: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى تأكيد كلمة المرور';
              }
              if (value != password.text) {
                return 'كلمتا المرور غير متطابقتين';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Terms and Conditions
          _buildTermsCheckbox(),

          const SizedBox(height: 24),

          // Register Button
          _buildRegisterButton(state, cubit),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordToggle,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Blue.withOpacity(0.1), Blue.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Blue, size: 18),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF64748B),
              size: 20,
            ),
            onPressed: onPasswordToggle,
          )
              : null,
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE8E8E8),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: Blue.withOpacity(0.7),
            fontSize: 13,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Transform.scale(
          scale: 1.1,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            activeColor: Blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
              children: [
                const TextSpan(text: "أوافق على "),
                TextSpan(
                  text: "شروط الاستخدام",
                  style: TextStyle(
                    color: Orange,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: " و "),
                TextSpan(
                  text: "سياسة الخصوصية",
                  style: TextStyle(
                    color: Orange,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthState state, AuthCubit cubit) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Orange, Orange.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (state is LoadingState || !_agreeToTerms)
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            HapticFeedback.lightImpact();
            cubit.create_user(
              data: {
                'first_name': first_name.text,
                'last_name': last_name.text,
                'phone': phone_number.text,
                'password': password.text,
                'confirm_password': confirm_password.text,
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state is LoadingState
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              "إنشاء حساب",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "لديك حساب بالفعل؟",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                "تسجيل الدخول",
                style: TextStyle(
                  color: Orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessAnimation() {
    HapticFeedback.heavyImpact();
    // Add success animation here
  }
}