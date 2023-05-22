import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  User? user;

  UserModel({ this.id,
    this.name,
    this.email,
    this.password,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['phone'];
  }

//  function to check if user is logged in
  bool get isAuth {
    return user != null;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;

  User({this.id, this.name, this.email, this.phone, this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

}
