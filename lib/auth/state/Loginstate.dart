abstract class LoginState {}

class LoginInitial extends LoginState {} // الحالة الأولية عند فتح التطبيق

class LoginLoading extends LoginState {} // عند الضغط على زر تسجيل الدخول

class LoginSuccess extends LoginInitial {
  final Map<String, dynamic> user;

  LoginSuccess({required this.user});
}
class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}
