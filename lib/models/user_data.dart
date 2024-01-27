class UserData {
  int? id;
  String? name;
  String? email;
  String? gender;
  String? city;
  String? state;
  String? phoneNumber;

  UserData(
      {this.id,
      this.name,
      this.email,
      this.gender,
      this.city,
      this.state,
      this.phoneNumber});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['gender'] = gender;
    data['state'] = state;
    data['city'] = city;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
