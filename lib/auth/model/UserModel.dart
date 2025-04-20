class ModelUserCreate {
  String firstName;
  String lastName;
  String phone;
  String password;
  String confirmPassword;

  ModelUserCreate({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  // لتحويل البيانات إلى JSON قبل الإرسال
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }

  // لو تبّي تنشئ النموذج من JSON (اختياري)
  factory ModelUserCreate.fromJson(Map<String, dynamic> json) {
    return ModelUserCreate(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      password: json['password'],
      confirmPassword: json['confirm_password'],
    );
  }
}
