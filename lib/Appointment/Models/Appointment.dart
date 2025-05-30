import 'package:arean/Doctors/models/DoctorModel.dart';

class AppointmentModel {
  final int id;
  late final String date;
  late final String period;
  final String? name;
  final String? age;
  late final String? type;
  final String states;
  final DoctorModel? doctor;

  AppointmentModel({
    required this.id,
    required this.date,
    required this.period,
    this.name,
    this.age,
    this.type,
    required this.states,
    this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      date: json['date'],
      period: json['period'],
      name: json['name'],
      age: json['age'],
      type: json['type'],
      states: json['states'],
      doctor: json['doctor'] != null ? DoctorModel.fromJson(json['doctor']) : null,
    );
  }
}

