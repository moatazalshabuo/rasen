import '../Models/Appointment.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSuccess extends AppointmentState {
  final List<AppointmentModel> appointments;
  AppointmentSuccess(this.appointments);
}
class oneAppointmentSuccess extends AppointmentState{}
class AppointmentFailure extends AppointmentState {
  final String message;
  AppointmentFailure(this.message);
}

// ✅ حالات التعديل
class UpdateAppointmentLoading extends AppointmentState {}

class UpdateAppointmentSuccess extends AppointmentState {
  final String message;
  UpdateAppointmentSuccess(this.message);
}

class UpdateAppointmentFailure extends AppointmentState {
  final String message;
  UpdateAppointmentFailure(this.message);
}