import 'package:appending_infotech_assignment/bloc/user_bloc.dart';
import 'package:appending_infotech_assignment/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddEditUserScreen extends StatefulWidget {
  final bool isEditing;
  final UserData? userData;

  const AddEditUserScreen({Key? key, this.isEditing = false, this.userData})
      : super(key: key);

  @override
  AddEditUserScreenState createState() => AddEditUserScreenState();
}

class AddEditUserScreenState extends State<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  // final List<String> _gender = ['Male', 'Female'];
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _nameController.text = widget.userData?.name ?? "";
      _emailController.text = widget.userData?.email ?? "";
      _stateController.text = widget.userData?.state ?? "";
      _cityController.text = widget.userData?.city ?? "";
      _phoneController.text = widget.userData?.phoneNumber ?? "";
    }
    _determinePosition();
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _cityController.text = placemarks.first.locality ?? 'Unknown City';
      _stateController.text =
          placemarks.first.administrativeArea ?? 'Unknown State';
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.isEditing) {
        UserData userData = UserData(
            city: _cityController.text,
            name: _nameController.text,
            state: _stateController.text,
            email: _emailController.text,
            phoneNumber: _phoneController.text,
            gender: _selectedGender,
            id: widget.userData?.id);
        BlocProvider.of<UserBloc>(context).add(
          UpdateUserData(
            id: widget.userData?.id ?? 0,
            userData: userData,
          ),
        );
      } else {
        UserData userData = UserData(
            city: _cityController.text,
            name: _nameController.text,
            state: _stateController.text,
            email: _emailController.text,
            phoneNumber: _phoneController.text,
            gender: _selectedGender,
            id: widget.userData?.id);
        BlocProvider.of<UserBloc>(context).add(
          AddUser(
            userData: userData,
          ),
        );
        print("Adding new user");
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              // TextFormField(
              //   controller: _genderController,
              //   decoration: const InputDecoration(labelText: 'Gender'),
              // ),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.isEditing ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
