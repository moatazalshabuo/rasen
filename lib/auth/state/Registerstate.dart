class AuthState{}

class initState extends AuthState{}
class LoadingState extends AuthState{}
class SuccessState extends AuthState{}
class FieldState extends AuthState{
  final String message;
  FieldState({required this.message});
}