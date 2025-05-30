import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../DefualtLayout.dart';
import '../../constant/colors.dart';
import '../../widgets/AppBar.dart';
import '../Widget/AppointmentCard.dart';
import '../cubit/AppoitmentCubit.dart';
import '../state/AppointmentState.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final List<String> filterLabels = ['الكل', 'تمت الموافقة', 'في انتظار الدفع', 'مرفوضة'];
  final List<String> filterKeys = ['all', 'active', 'whit_paid', 'rejected'];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AppointmentCubit>();
    cubit.fetchAppointments().then((_) {
      // Re-apply the last selected filter
      cubit.filterByStateLabel(filterKeys[selectedIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Defualtlayout(
      title: 'حجوزاتي',
      body: SafeArea(
        child: Column(
          children: [
            // ✅ عنوان الصفحة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: AppBarCustom(context, 'حجوزاتي', true),
            ),

            // ✅ فلترة المواعيد باستخدام ChoiceChips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(filterLabels.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(
                        filterLabels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Blue,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => selectedIndex = index);
                        context.read<AppointmentCubit>().filterByStateLabel(filterKeys[index]);
                      },
                      selectedColor: Blue,
                      backgroundColor: Blue.withOpacity(0.1),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ محتوى المواعيد
            Expanded(
              child: BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoading) {
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  }

                  if (state is AppointmentFailure) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }

                  if (state is AppointmentSuccess) {
                    final appointments = state.appointments;
                    if (appointments.isEmpty) {
                      return const Center(
                        child: Text('لا توجد حجوزات حالياً', style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: appointments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return AppointmentBookingCard(
                          appointment: appointments[index],
                          isFavorite: false,
                          onBook: () {},
                          onToggleFavorite: () {},
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
