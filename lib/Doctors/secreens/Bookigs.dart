import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:quickalert/quickalert.dart';
import 'package:arean/constant/colors.dart';
import 'package:arean/Doctors/cubit/DoctorCubit.dart';
import 'package:arean/Doctors/state/DoctorState.dart';
import 'package:arean/widgets/SnackBar.dart';
import 'package:arean/DefualtLayout.dart';

import '../../auth/secrees/Login.dart';
import '../../widgets/Drawer.dart';
import 'Confirmation.dart';

class BookingPage extends StatelessWidget {
  final int doctorId;

  BookingPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorCubit>();
    cubit.getDoctor(doctorId);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Defualtlayout(
        title: '',
        body: BlocConsumer<DoctorCubit, DoctorState>(
          listener: (context, state) {
            if (state is FailedAppointmentState) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: state.message,
              );
            }
            if (state is SuccessAppointmentState) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "تم الحجز بنجاح",
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingDotorProfileState ||
                state is LoadingAppointmentState) {
              return const _LoadingView();
            }

            if (cubit.doctorProfile == null) {
              return const _ErrorView();
            }

            final doctor = cubit.doctorProfile!;
            final schedules = doctor.schedules;

            return _BookingContent(
              doctor: doctor,
              cubit: cubit,
              schedules: schedules,
            );
          },
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            "جاري تحميل بيانات الطبيب...",
            style: TextStyle(color: Blue, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            "حدث خطأ أثناء تحميل بيانات الطبيب",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<DoctorCubit>().getDoctor(
                context.read<DoctorCubit>().doctorProfile?.id ?? 0,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "إعادة المحاولة",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingContent extends StatelessWidget {
  final dynamic doctor;
  final DoctorCubit cubit;
  final List schedules;

  const _BookingContent({
    required this.doctor,
    required this.cubit,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DoctorHeader(doctor: doctor),
          const SizedBox(height: 16),
          _SectionTitle(title: 'اختيار الموعد'),
          _CalendarCard(cubit: cubit, schedules: schedules),
          _TimePeriodSelector(cubit: cubit),
          _BookingButton(cubit: cubit),
        ],
      ),
    );
  }
}

class _DoctorHeader extends StatelessWidget {
  final dynamic doctor;

  const _DoctorHeader({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Blue, Blue.withOpacity(0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'حجز موعد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    final firstName = prefs.getString('first_name') ?? '';
                    final lastName = prefs.getString('last_name') ?? '';
                    final username = prefs.getString('username') ?? '';

                    SmartDialog.show(
                      alignment: Alignment.centerLeft,
                      clickMaskDismiss: true,
                      backDismiss: true,
                      builder:
                          (_) => buildCustomDrawer(
                            fullName: '$firstName $lastName',
                            username: username,
                            photoUrl: 'https://i.pravatar.cc/150?img=3',
                            context: context,
                            logout: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                              );
                            },
                          ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Hero(
                  tag: 'doctor-${doctor.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(
                          '${const String.fromEnvironment('URL')}${doctor.photo}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "د. ${doctor.fullName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${doctor.specialty}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _RatingIndicator(rating: 4.5),
                          const SizedBox(width: 12),
                          _ExperienceChip(
                            years: doctor.profile.experienceYears ?? 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingIndicator extends StatelessWidget {
  final double rating;

  const _RatingIndicator({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ExperienceChip extends StatelessWidget {
  final int years;

  const _ExperienceChip({required this.years});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$years سنوات خبرة",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Blue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: Blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final DoctorCubit cubit;
  final List schedules;

  const _CalendarCard({required this.cubit, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'التقويم',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'اختر يومًا',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TableCalendar(
            onDaySelected:
                (selectedDay, focusedDay) => cubit.selectDay(selectedDay),
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: cubit.selected_day,
            enabledDayPredicate: (day) {
              return schedules
                  .map((e) => cubit.getArabicWeekdayName(e.day))
                  .toList()
                  .contains(day.weekday);
            },
            selectedDayPredicate: (day) {
              return isSameDay(day, cubit.selected_day);
            },
            calendarStyle: CalendarStyle(
              disabledTextStyle: const TextStyle(color: Colors.grey),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.2),
                border: Border.all(color: Colors.red, width: 1),
              ),
              todayTextStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: BoxDecoration(
                color: Blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Blue.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            availableGestures: AvailableGestures.horizontalSwipe,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePeriodSelector extends StatelessWidget {
  final DoctorCubit cubit;

  const _TimePeriodSelector({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4, bottom: 12),
            child: Text(
              'الفترة',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _PeriodOption(
                  icon: Icons.sunny,
                  title: 'صباحًا',
                  subtitle: '9:00 - 12:00',
                  isSelected: cubit.pairod == 'morning',
                  isDisabled: cubit.CheckAvilabelty('morning'),
                  onTap: () => cubit.ChangePirod('morning'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PeriodOption(
                  icon: Icons.nightlight,
                  title: 'مساءً',
                  subtitle: '16:00 - 20:00',
                  isSelected: cubit.pairod == 'evening',
                  isDisabled: cubit.CheckAvilabelty('evening'),
                  onTap: () => cubit.ChangePirod('evening'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _PeriodOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? Colors.grey.shade200
                  : isSelected
                  ? Blue.withOpacity(0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isDisabled
                    ? Colors.grey.shade300
                    : isSelected
                    ? Blue
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Blue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isDisabled
                      ? Colors.grey
                      : isSelected
                      ? Blue
                      : Colors.orange,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color:
                    isDisabled
                        ? Colors.grey
                        : isSelected
                        ? Blue
                        : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            if (isDisabled)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'غير متاح',
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookingButton extends StatelessWidget {
  final DoctorCubit cubit;

  const _BookingButton({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (cubit.pairod != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (context) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const ConfirmBookingSheet(),
                  ),
            );
          } else {
            showSuccessSnackBar(context, 'يرجى اختيار الفترة', 'error');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Blue,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "تأكيد الحجز",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
