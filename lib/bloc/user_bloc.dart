import 'package:appending_infotech_assignment/models/user_data.dart';
import 'package:appending_infotech_assignment/service/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserService userService = UserService();
  List<UserData> userData = [];
  int page = 1;
  UserBloc() : super(UserInitial()) {
    on<GetUserData>((event, emit) async {
      try {
        emit(UserLoading());
        List<UserData> data = await userService.fetchUsers(page) ?? [];
        page++;
        for (int i = 0; i < data.length; i++) {
          userData.add(data[i]);
        }
        emit(UserFetched(userData: userData));
      } catch (e) {
        print(e.toString());
      }
    });
    on<GetNextUserData>((event, emit) async {
      try {
        List<UserData> data = await userService.fetchUsers(page) ?? [];
        page++;
        for (int i = 0; i < data.length; i++) {
          userData.add(data[i]);
        }
        emit(UserFetched(userData: userData));
      } catch (e) {
        print(e.toString());
      }
    });
    on<UpdateUserData>((event, emit) async {
      try {
        emit(UserLoading());
        await userService.updateUser(event.id, event.userData);
        userData = userData
            .map((element) => element.id == event.id ? event.userData : element)
            .toList();
        print('updateUserDateBlocCalled');
        print(event.userData.name);
        print(event.userData.gender);
        emit(UserFetched(userData: userData));
      } catch (e) {
        print(e.toString());
      }
    });
    on<AddUser>((event, emit) async {
      try {
        emit(UserLoading());

        await userService.addUser(event.userData);
        userData.add(event.userData);
        print(event.userData.gender);
        // print('gfd');
        emit(UserFetched(userData: userData));
      } catch (e) {
        print(e.toString());
      }
    });
    on<DeleteUser>((event, emit) async {
      try {
        emit(UserLoading());

        await userService.deleteUser(event.id);
        userData.removeWhere((element) => element.id == event.id);
        print('Delete User Data Bloc Called');
        emit(UserFetched(userData: userData));
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
