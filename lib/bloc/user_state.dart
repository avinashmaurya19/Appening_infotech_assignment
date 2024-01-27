part of 'user_bloc.dart';

sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserFetched extends UserState{
  final List<UserData> userData;

  UserFetched({required this.userData});
}

class UserUpdated extends UserState{}

class UserDeleted extends UserState{}