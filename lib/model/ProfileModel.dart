class UserProfileModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
