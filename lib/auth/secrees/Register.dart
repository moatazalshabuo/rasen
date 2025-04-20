import 'package:arean/auth/cubit/Registercubit.dart';
import 'package:arean/auth/state/Registerstate.dart';
import 'package:arean/constant/colors.dart';

import 'package:arean/auth/secrees/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

const PrimaryColor = Color(0xFF406B86); // الأزرق الرمادي
const AccentOrange = Color(0xFFFF8A00); // البرتقالي

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  var phone_number = TextEditingController();
  var first_name = TextEditingController();
  var last_name = TextEditingController();
  var password = TextEditingController();
  var confirm_password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SuccessState) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('تم التسجيل بنجاح'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Transaction Completed Successfully!',
            onConfirmBtnTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          );
        }

        if (state is FieldState) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'خطاء',
            text: state.message,
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl, // دعم اللغة العربية
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),

                    // ✅ الشعار
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/logo.png',
                          // height: 100,
                          width: 150,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ✅ عنوان ترحيبي
                    const Text(
                      "مرحبًا بك 👋",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "يرجى تسجيل الدخول للمتابعة",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    // 📨 البريد الإلكتروني
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: first_name,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "الاسم الاول",
                              prefixIcon: const Icon(
                                Icons.supervised_user_circle_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 📨 البريد الإلكتروني
                          TextFormField(
                            controller: last_name,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "الاسم الاخير",
                              prefixIcon: const Icon(
                                Icons.supervised_user_circle_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 📨 البريد الإلكتروني
                          TextFormField(
                            controller: phone_number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "رقم الهاتف",
                              prefixIcon: const Icon(Icons.phone_android),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 🔒 كلمة المرور
                          TextFormField(
                            controller: password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "كلمة المرور",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 🔒 كلمة المرور
                          TextFormField(
                            controller: confirm_password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter confirm password';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "تاكيد كلمة المرور",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔘 زر الدخول
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (password.text != confirm_password.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('كلمتا المرور غير متطابقتين'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // استدعاء Cubit للتسجيل
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

                          // /Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "تسجيل ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ➕ ليس لديك حساب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "لدي حساب؟",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed:
                              () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                ),
                              },
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              color: Orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
