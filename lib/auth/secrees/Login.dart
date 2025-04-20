import 'package:arean/auth/cubit/LoginCubit.dart';
import 'package:arean/constant/colors.dart';
import 'package:arean/screens/Home.dart';
import 'package:arean/auth/secrees/Register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../state/Loginstate.dart';
 // البرتقالي

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formkey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم اللغة العربية
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            } else if (state is LoginError) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'خطاء',
                text: "فشل تسجيل الدخول",
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(child: const CircularProgressIndicator());
            }
            return SafeArea(
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
                          borderRadius: BorderRadius.circular(50)
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 📨 البريد الإلكتروني
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "رقم الهاتف",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          // 🔒 كلمة المرور
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔘 زر الدخول
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()
                          {
                            context.read<LoginCubit>().loginUser(phoneController.text, passwordController.text);
                          }
                        ,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 أو بواسطة
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "أو بواسطة",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🟦 أزرار تسجيل الدخول الخارجية
                    Row(
                      children: [
                        // 📘 Facebook
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.facebook, color: Colors.white),
                            label: const Text("فيسبوك"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1877F2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 🟥 Gmail
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset("assets/google.png", height: 20),
                            label: const Text(
                              "جوجل",
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black12),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ➕ ليس لديك حساب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ليس لديك حساب؟", style: TextStyle(color: Colors.black54)),
                        SizedBox(width: 4),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                          },
                          child: Text(
                            "سجل الآن",
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
            );

          },
        )

      ),
    );
  }
}
