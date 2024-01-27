part of 'user_bloc.dart';

sealed class UserEvent {}

class GetUserData extends UserEvent {

  GetUserData();
  
}
class GetNextUserData extends UserEvent {

  GetNextUserData();
  
}

class UpdateUserData extends UserEvent {
  final int id;
  final UserData userData;

  UpdateUserData({required this.id,required this.userData});
}
class AddUser extends UserEvent {
  final UserData userData;

  AddUser({required this.userData});
}

class DeleteUser extends UserEvent {
  final int id;

  DeleteUser({required this.id});
}
