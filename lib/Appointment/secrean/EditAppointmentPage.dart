import 'package:arean/Appointment/secrean/AppointmentDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Appointment/Models/Appointment.dart';
import '../../Appointment/cubit/AppoitmentCubit.dart';
import '../../Appointment/state/AppointmentState.dart';
import '../../Doctors/cubit/DoctorCubit.dart';
import '../../Doctors/widgets/SelectButton.dart';
import '../../constant/colors.dart';
import '../../widgets/TextForm.dart';
import '../../DefualtLayout.dart';

class Editappointmentpage extends StatefulWidget {
  final AppointmentModel appointmentModel;

  const Editappointmentpage({super.key, required this.appointmentModel});

  @override
  State<Editappointmentpage> createState() => _EditappointmentpageState();
}

class _EditappointmentpageState extends State<Editappointmentpage> {
  late TextEditingController nameController;
  late TextEditingController ageController;

  late DateTime selectedDate = DateTime.now();
  String? selectedPeriod;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.appointmentModel.name ?? '',
    );
    ageController = TextEditingController(
      text: widget.appointmentModel.age ?? '',
    );
    selectedDate = DateTime.parse(widget.appointmentModel.date);

    selectedPeriod = widget.appointmentModel.period;
    selectedType = widget.appointmentModel.type;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorCubit>();
    final schedules = widget.appointmentModel.doctor!.schedules;

    return Defualtlayout(
      title: '',
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is UpdateAppointmentSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AppointmentDetailPage(
                      appointment: widget.appointmentModel,
                    ),
              ),
            );
          } else if (state is UpdateAppointmentFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'اختيار الموعد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Blue,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // child: TableCalendar(
                  //   onDaySelected: (selectedDay, _) {
                  //     setState(() {
                  //       selectedDate = selectedDay;
                  //     });
                  //   },
                  //   firstDay: DateTime.now(),
                  //   lastDay: DateTime.utc(2030, 12, 31),
                  //   focusedDay: selectedDate,
                  //   selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                  //   enabledDayPredicate: (day) {
                  //     return schedules
                  //         .map((e) => cubit.getArabicWeekdayName(e.day))
                  //         .contains(day.weekday);
                  //   },
                  //   calendarStyle: CalendarStyle(
                  //     todayDecoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  //     selectedDecoration: BoxDecoration(color: Blue, shape: BoxShape.circle),
                  //     selectedTextStyle: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  child: TableCalendar(
                    onDaySelected:
                        (selectedDay, focusedDay) => setState(() {
                          selectedDate = selectedDay;
                        }),
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 90)),
                    focusedDay: selectedDate,
                    enabledDayPredicate: (day) {
                      return schedules
                          .map((e) => cubit.getArabicWeekdayName(e.day))
                          .toList()
                          .contains(day.weekday);
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(day, selectedDate);
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
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildSelectionButton(
                              desibled: cubit.PublicCheckAvilabelty(
                                'evening',
                                selectedDate.weekday,
                                schedules,
                              ),
                              title: "مساء",
                              isSelected: selectedPeriod == 'evening',
                              icon: Icons.nightlight,
                              onTap:
                                  () => setState(
                                    () => selectedPeriod = 'evening',
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildSelectionButton(
                              desibled: cubit.PublicCheckAvilabelty(
                                'morning',
                                selectedDate.weekday,
                                schedules,
                              ),
                              title: "صباح",
                              isSelected: selectedPeriod == 'morning',
                              icon: Icons.sunny,
                              onTap:
                                  () => setState(
                                    () => selectedPeriod = 'morning',
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // نوع الحجز
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
                            const Text(
                              "نوع الحجز",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: buildSelectionButton(
                                    desibled: false,
                                    title: "حجز جديد",
                                    isSelected: selectedType == 'new',
                                    icon: Icons.add_circle_outline,
                                    onTap:
                                        () => setState(
                                          () => selectedType = 'new',
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: buildSelectionButton(
                                    desibled: false,
                                    title: "مراجعة",
                                    isSelected: selectedType == 'review',
                                    icon: Icons.history,
                                    onTap:
                                        () => setState(
                                          () => selectedType = 'review',
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // بيانات الشخص
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
                            const Text(
                              "بيانات الشخص",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildTextField(
                              controller: nameController,
                              labelText: "اسم الشخص",
                              icon: Icons.person_outline,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? 'الرجاء إدخال اسم الشخص'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            buildTextField(
                              controller: ageController,
                              labelText: "العمر",
                              icon: Icons.calendar_today,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'الرجاء إدخال العمر';
                                if (int.tryParse(value) == null)
                                  return 'الرجاء إدخال رقم صحيح';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.all(30),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      context
                          .read<AppointmentCubit>()
                          .updateAppointment(widget.appointmentModel.id, {
                            'name': nameController.text,
                            'age': ageController.text,
                            'date': DateFormat.yMMMd().format(selectedDate),
                            'period': selectedPeriod,
                            'type': selectedType,
                            'doctor_id': widget.appointmentModel.doctor?.id,
                            'states': widget.appointmentModel.states,
                          });
                    },
                    child: const Text(
                      "تأكيد التعديل",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
