import '../model/ProfileModel.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfileModel user;

  ProfileSuccess(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}

class ProfileUpdated extends ProfileState {
  final String message;
  final UserProfileModel user;

  ProfileUpdated(this.message, this.user);
}
