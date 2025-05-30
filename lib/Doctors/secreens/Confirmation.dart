import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constant/colors.dart';
import '../cubit/DoctorCubit.dart';
import '../widgets/SelectButton.dart';

class ConfirmBookingSheet extends StatefulWidget {
  const ConfirmBookingSheet({super.key});

  @override
  State<ConfirmBookingSheet> createState() => _ConfirmBookingSheetState();
}

class _ConfirmBookingSheetState extends State<ConfirmBookingSheet> {
  String whoFor = 'me';
  String bookingType = 'new';
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cubit = context.read<DoctorCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Blue, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        "تأكيد الحجز",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Blue,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 24),
                  //
                  // // Booking for whom section
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[50],
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(color: Colors.grey[200]!),
                  //   ),
                  //   padding: const EdgeInsets.all(16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "الحجز لـ",
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.grey[800],
                  //         ),
                  //       ),
                  //       const SizedBox(height: 12),
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: _buildSelectionButton(
                  //               title: "لي",
                  //               isSelected: whoFor == 'me',
                  //               icon: Icons.person,
                  //               onTap: () => setState(() => whoFor = 'me'),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 12),
                  //           Expanded(
                  //             child: _buildSelectionButton(
                  //               title: "لشخص آخر",
                  //               isSelected: whoFor == 'other',
                  //               icon: Icons.people,
                  //               onTap: () => setState(() => whoFor = 'other'),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 20),

                  // Booking type section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "نوع الحجز",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: buildSelectionButton(
                                desibled: false,
                                title: "حجز جديد",
                                isSelected: bookingType == 'new',
                                icon: Icons.add_circle_outline,
                                onTap:
                                    () => setState(() => bookingType = 'new'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: buildSelectionButton(
                                desibled: false,
                                title: "مراجعة",
                                isSelected: bookingType == 'review',
                                icon: Icons.history,
                                onTap:
                                    () =>
                                        setState(() => bookingType = 'review'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Additional fields if booking for someone else
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "بيانات الشخص",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: nameController,
                          labelText: "اسم الشخص",
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اسم الشخص';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: ageController,
                          labelText: "العمر",
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال العمر';
                            }
                            if (int.tryParse(value) == null) {
                              return 'الرجاء إدخال رقم صحيح';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit
                              .createAppointment(
                                data: {
                                  'name': nameController.text,
                                  'age': ageController.text,
                                  'type': bookingType,
                                },
                              )
                              .then((onValue) {
                                Navigator.pop(context);
                                // _showSuccessSnackBar(context);
                              });
                        } else {
                          return;
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "إتمام الحجز",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: Blue, size: 22),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  // void _showSuccessSnackBar(BuildContext context) {
  //   final snackBar = SnackBar(
  //     content: Row(
  //       children: [
  //         const Icon(Icons.check_circle, color: Colors.white),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             whoFor == 'other'
  //                 ? "تم الحجز لـ ${nameController.text} (${ageController.text} سنة) بنجاح"
  //                 : "تم الحجز لك بنجاح",
  //             style: const TextStyle(fontWeight: FontWeight.w500),
  //           ),
  //         ),
  //       ],
  //     ),
  //     backgroundColor: Colors.green,
  //     behavior: SnackBarBehavior.floating,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     margin: const EdgeInsets.all(16),
  //     duration: const Duration(seconds: 3),
  //     action: SnackBarAction(
  //       label: 'إغلاق',
  //       textColor: Colors.white,
  //       onPressed: () {},
  //     ),
  //   );
  //
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
}
