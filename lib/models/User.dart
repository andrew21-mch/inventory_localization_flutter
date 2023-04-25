import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  int? id;
  String? name;
  String? email;
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
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;

  User({this.id, this.name, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

}
