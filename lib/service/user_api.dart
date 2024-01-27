import 'dart:convert';
import 'package:appending_infotech_assignment/models/user_data.dart';
import 'package:http/http.dart' as http;

const String apiUrl = "https://gorest.co.in/public/v2/users";

class UserService {
  Future<List<UserData>?> fetchUsers(int page) async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl?page=$page&per_page=10'));
      if (response.statusCode == 200) {
        List<UserData> userData = List<UserData>.from(
            jsonDecode(response.body).map((x) => UserData.fromJson(x)));
        return userData;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> deleteUser(int userId) async {
    try {
      await http.delete(Uri.parse('$apiUrl/$userId'));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUser(int userId,UserData userData) async {
    try {
      await http.post(Uri.parse('$apiUrl/$userId'), body: {
        "name": userData.name,
        "gender": userData.gender,
        "email": userData.email,
        "phone":userData.phoneNumber,
        "city": userData.city,
        "state": userData.state,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addUser(UserData userData) async {
     try {
      await http.post(Uri.parse(apiUrl), body: {
        "name": userData.name,
        "gender": userData.gender,
        "email": userData.email,
        "phone":userData.phoneNumber,
        "city": userData.city,
        "state": userData.state,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
