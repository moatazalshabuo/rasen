
class DoctorProfile {
  final int? experienceYears;
  final String? bio;
  final String? certifications;


  DoctorProfile({
    this.experienceYears,
    this.bio,
    this.certifications,

  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      experienceYears: json['experience_years'],
      bio: json['bio'],
      certifications: json['certifications'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experience_years': experienceYears,
      'bio': bio,
      'certifications': certifications,

    };
  }
}