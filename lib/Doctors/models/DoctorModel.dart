import 'DoctorProfile.dart';
import 'DoctorSchdule.dart';


class DoctorModel {
  final int id;
  final String fullName;
  final String gender;
  final String specialty;
  final String role;
  final String? photo;
  final DoctorProfile? profile;
  final List<DoctorSchedule> schedules;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.specialty,
    required this.role,
    required this.photo,
    this.profile,
    required this.schedules,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      fullName: json['full_name'],
      gender: json['gender'],
      specialty: json['specialty'],
      role: json['role'],
      photo: json['photo'],
      profile: json['profile'] != null
          ? DoctorProfile.fromJson(json['profile'])
          : null,
      schedules: json['schedules'] != null
          ? List<DoctorSchedule>.from(
          json['schedules'].map((x) => DoctorSchedule.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'gender': gender,
      'specialty': specialty,
      'role': role,
      'photo': photo,
      'profile': profile?.toJson(),
      'schedules': schedules.map((x) => x.toJson()).toList(),
    };
  }
}
