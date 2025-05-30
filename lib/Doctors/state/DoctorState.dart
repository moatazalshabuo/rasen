interface class DoctorState{}

class initState extends DoctorState{}

class  LoadingDotorProfileState extends DoctorState{}

class  SuccessDotorProfileState extends DoctorState{}

class  FieldDotorProfileState extends DoctorState{}

class ChangeSelectedDayState extends DoctorState {}

class FailedAppointmentState extends DoctorState {
  final String message;
  FailedAppointmentState({required this.message});
}
class SuccessAppointmentState extends DoctorState{}
class LoadingAppointmentState extends DoctorState{}

class ChangePirodState extends DoctorState{}