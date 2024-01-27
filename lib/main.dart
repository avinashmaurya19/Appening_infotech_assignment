import 'package:appending_infotech_assignment/bloc/user_bloc.dart';
import 'package:appending_infotech_assignment/user_form_screen.dart';
import 'package:appending_infotech_assignment/user_liist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final myBloc = UserBloc();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => myBloc,
        child: const UserListScreen(),
      ),
      routes: {
        '/add': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;
          return BlocProvider.value(
            value: myBloc,
            child: AddEditUserScreen(
              isEditing: args?['isEditing'] ?? false,
              userData: args?['userData'],
            ),
          );
        }
      },
    );
  }
}
