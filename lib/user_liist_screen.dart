import 'package:appending_infotech_assignment/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(GetUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          print(state);
          if (state is UserFetched) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  // User has reached the end of the list
                  // Load more data or trigger pagination in flutter
                  BlocProvider.of<UserBloc>(context).add(GetNextUserData());
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.userData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.userData[index].name ?? ""),
                    subtitle: Text(
                        '${state.userData[index].email ?? ""} - ${state.userData[index].gender ?? ""}'),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'remove',
                          child: Text('Remove'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.pushNamed(context, '/add', arguments: {
                            "isEditing": true,
                            "userData": state.userData[index],
                          });
                        }
                        //  else if (value == 'remove') {
                        //   BlocProvider.of<UserBloc>(context).add(
                        //       DeleteUser(id: state.userData[index].id ?? 0));
                        // }
                        else if (value == 'remove') {
                          print('remove button clicked');
                          showDialog(
                              context: context,
                              builder: (context1) {
                                return AlertDialog(
                                  title:
                                      const Text("are you sure want to delete"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('NO')),
                                    TextButton(
                                      onPressed: () {
                                        BlocProvider.of<UserBloc>(context).add(
                                            DeleteUser(
                                                id: state.userData[index].id ??
                                                    0));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
