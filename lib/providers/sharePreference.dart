import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ilocate/models/User.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _token = '';
  int? _id;
  String get token => _token;
  int? get id => _id;
  void saveToken(String token) async {
    SharedPreferences value = await _prefs;
    value.setString('token', token);
  }
  void saveId(int id) async {
    SharedPreferences value = await _prefs;
    value.setInt('id', id);
  }

  //method to save the user object from the api
  void saveUserName(String name) async {
    SharedPreferences value = await _prefs;
    value.setString('name', name);
  }

  Future<String> getToken() async {
    SharedPreferences value = await _prefs;
    if (value.containsKey('token')) {
      String data = value.getString('token') as String;
      _token = data;
      notifyListeners();
      return _token;
    } else {
      _token = '';
      notifyListeners();
      return '';
    }
  }

  Future<int> getUserId() async {
    SharedPreferences value = await _prefs;
    if (value.containsKey('id')) {
      int data = value.getString('id') as int;
      _id = data;
      notifyListeners();
      return data;
    } else {
      _id;
      notifyListeners();
      return '' as int;
    }
  }

  void logout(BuildContext context) async {
    final value = await _prefs;
    value.clear();
    Get.to(const Login(),
        transition: Transition.fade,
        curve: Curves.easeOut,
        duration: const Duration(microseconds: 800));
  }
}
