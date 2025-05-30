import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:arean/Appointment/cubit/AppoitmentCubit.dart';
import 'package:arean/Appointment/state/AppointmentState.dart';
import 'package:arean/DefualtLayout.dart';
import 'package:arean/Doctors/secreens/DoctorProfile.dart';
import 'package:arean/Appointment/Models/Appointment.dart';
import '../../Doctors/state/DoctorState.dart';
import '../../constant/colors.dart';
import 'EditAppointmentPage.dart';

class AppointmentDetailPage extends StatelessWidget {
  final AppointmentModel? appointment;

   AppointmentDetailPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentCubit>();
    cubit.fetchAppointment(id: appointment!.id);

    return Defualtlayout(
      title: '',
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          // يمكن إضافة استماع للأحداث هنا
        },
        builder: (context, state) {
          if (state is LoadingAppointmentState) {
            return  _LoadingView();
          } else if (state is oneAppointmentSuccess && cubit.activeAppointment != null) {
            return _AppointmentDetailsContent(
              appointment: cubit.activeAppointment!,
              cubit: cubit,
            );
          } else if (state is AppointmentFailure) {
            return _ErrorView(message: state.message);
          } else {
            return  _NoDataView();
          }
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
   _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Blue),
          ),
           SizedBox(height: 20),
          Text(
            "جاري تحميل تفاصيل الحجز...",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

   _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 70,
            color: Colors.red.shade300,
          ),
           SizedBox(height: 20),
          Text(
            message,
            style:  TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
           SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AppointmentCubit>().fetchAppointment(
                  id: context.read<AppointmentCubit>().activeAppointment?.id ?? 0);
            },
            icon:  Icon(Icons.refresh),
            label:  Text("إعادة المحاولة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Blue,
              foregroundColor: Colors.white,
              padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoDataView extends StatelessWidget {
   _NoDataView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:  EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
           SizedBox(height: 20),
           Text(
            "لا توجد بيانات متاحة لهذا الحجز",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
           SizedBox(height: 12),
          Text(
            "يرجى التحقق من الرقم المرجعي للحجز والمحاولة مرة أخرى",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AppointmentDetailsContent extends StatelessWidget {
  final AppointmentModel appointment;
  final AppointmentCubit cubit;

   _AppointmentDetailsContent({
    required this.appointment,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;
    final formattedDate = DateFormat.yMMMd().format(
      DateTime.parse(appointment.date),
    );

    return SingleChildScrollView(
      physics:  BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AppointmentHeader(
            appointment: appointment,
            formattedDate: formattedDate,
          ),
          _AppointmentStatus(status: appointment.states),
          _PatientInformation(appointment: appointment),
          _DoctorInformation(doctor: doctor),
          _ActionButtons(appointment: appointment),
        ],
      ),
    );
  }
}

class _AppointmentHeader extends StatelessWidget {
  final AppointmentModel appointment;
  final String formattedDate;

   _AppointmentHeader({
    required this.appointment,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    String appointmentPeriod = appointment.period == "morning" ? "صباحًا" : "مساءً";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Blue,
            Blue.withOpacity(0.7),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius:  BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Blue.withOpacity(0.3),
            blurRadius: 20,
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // أيقونة الرجوع والعنوان
            Padding(
              padding:  EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Row(
                children: [
                  IconButton(
                    icon:  Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                   Expanded(
                    child: Text(
                      'تفاصيل الحجز',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon:  Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () {
                      // مشاركة الحجز
                    },
                  ),
                ],
              ),
            ),

            // رمز QR
            Container(
              margin:  EdgeInsets.symmetric(vertical: 20),
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset:  Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    version: QrVersions.auto,
                    data: "${appointment.id}",
                    size: 170.0,
                    eyeStyle:  QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Blue,
                    ),
                    dataModuleStyle:  QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Blue,
                    ),
                  ),
                   SizedBox(height: 12),
                  Text(
                    "رمز الحجز: ${appointment.id}",
                    style:  TextStyle(
                      color: Blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // التاريخ والوقت
            Container(
              margin:  EdgeInsets.only(bottom: 24, top: 8, left: 20, right: 20),
              padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.calendar_today, size: 18, color: Colors.white),
                   SizedBox(width: 8),
                  Text(
                    '$formattedDate',
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                   SizedBox(width: 16),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white.withOpacity(0.5),
                  ),
                   SizedBox(width: 16),
                   Icon(Icons.access_time_rounded, size: 18, color: Colors.white),
                   SizedBox(width: 8),
                  Text(
                    appointmentPeriod,
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentStatus extends StatelessWidget {
  final String status;

   _AppointmentStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor, bgColor, iconData) = _getStatusInfo(status);

    return Container(
      margin:  EdgeInsets.fromLTRB(20, 24, 20, 12),
      padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding:  EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: statusColor, size: 20),
          ),
           SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "حالة الحجز",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                 SizedBox(height: 4),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (status == 'whit_paid')
            ElevatedButton.icon(
              onPressed: () {
                // عملية الدفع
              },
              icon:  Icon(Icons.payment, size: 16),
              label:  Text("دفع"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Blue,
                foregroundColor: Colors.white,
                padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  (String, Color, Color, IconData) _getStatusInfo(String status) {
    switch (status) {
      case 'active':
        return ('تمت الموافقة', Colors.green, Colors.green.withOpacity(0.1), Icons.check_circle);
      case 'whit_paid':
        return ('في انتظار الدفع', Colors.orange, Colors.orange.withOpacity(0.1), Icons.payment);
      case 'rejected':
        return ('مرفوض', Colors.red, Colors.red.withOpacity(0.1), Icons.cancel);
      default:
        return ('غير معروف', Colors.grey, Colors.grey.withOpacity(0.1), Icons.help_outline);
    }
  }
}

class _PatientInformation extends StatelessWidget {
  final AppointmentModel appointment;

   _PatientInformation({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.fromLTRB(20, 12, 20, 20),
      padding:  EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:  EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:  Icon(Icons.person, color: Blue, size: 20),
              ),
               SizedBox(width: 12),
               Text(
                "معلومات المريض",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
               Spacer(),
              Container(
                padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appointment.type == "new" ? "حجز جديد" : "مراجعة",
                  style:  TextStyle(
                    color: Orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
           SizedBox(height: 20),

          // اسم المريض
          _InfoRow(
            icon: Icons.badge_outlined,
            label: "الاسم",
            value: appointment.name ?? 'غير متوفر',
          ),
           SizedBox(height: 12),

          // عمر المريض
          _InfoRow(
            icon: Icons.cake_outlined,
            label: "العمر",
            value: "${appointment.age ?? '--'} سنة",
          ),

          // هنا يمكن إضافة معلومات أخرى مثل رقم الهاتف أو البريد الإلكتروني إذا كانت متوفرة
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

   _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
         SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style:  TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _DoctorInformation extends StatelessWidget {
  final dynamic doctor;

   _DoctorInformation({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding:  EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:  EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:  Icon(Icons.medical_services_outlined, color: Blue, size: 20),
              ),
               SizedBox(width: 12),
               Text(
                "الطبيب المعالج",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
           SizedBox(height: 16),

          // معلومات الطبيب مع صورته
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(doctor_id: doctor.id),
                ),
              );
            },
            child: Container(
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Blue.withOpacity(0.3), width: 2),
                      image: DecorationImage(
                        image: NetworkImage('${ URL}${doctor.photo}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                   SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "د. ${doctor.fullName}",
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                         SizedBox(height: 4),
                        Text(
                          "${doctor.specialty}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:  EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Blue,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final AppointmentModel appointment;

   _ActionButtons({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              icon:  Icon(Icons.delete_outline, size: 18),
              label:  Text("حذف الحجز"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                elevation: 0,
                padding:  EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.shade300),
                ),
              ),
            ),
          ),
           SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(

              onPressed: () {
                print(DateTime.now().difference(DateTime.parse(appointment.date)).inDays);
                if(DateTime.now().difference(DateTime.parse(appointment.date)).inDays <= 0) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Editappointmentpage(
                              appointmentModel: appointment),
                        ),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تاريخ الموعد اصبح قديم لايمكن تعديله'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon:  Icon(Icons.edit_outlined, size: 18),
              label:  Text("تعديل الحجز"),

              style: ElevatedButton.styleFrom(
                backgroundColor: Blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:  EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

              ),

            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:  Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text("تأكيد الحذف"),
          ],
        ),
        content:  Text(
          "هل أنت متأكد من حذف هذا الحجز؟ لا يمكن التراجع عن هذه العملية.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              // تنفيذ عملية الحذف
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:  Text("حذف"),
          ),
        ],
      ),
    );
  }
}