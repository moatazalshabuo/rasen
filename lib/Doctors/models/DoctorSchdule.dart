class DoctorSchedule {
  final int id;
  final String day;
  final String period;
  final String startTime;
  final String endTime;

  DoctorSchedule({
    required this.id,
    required this.day,
    required this.period,
    required this.startTime,
    required this.endTime,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      id: json['id'],
      day: json['day'],
      period: json['period'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
