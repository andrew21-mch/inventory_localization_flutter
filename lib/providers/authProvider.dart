import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ilocate/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;
  bool get isLoading => _isLoading;
  String get failureMessage => _failureMessage;

  void register(
      {
        required String name,
        required String email,
        required String password,
        required String phone}) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.register;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8'
    };
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };

    http.Response req = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        if (kDebugMode) {
          print(res);
        }
        _isLoading = false;
        _reqMessage = res['status'];
        notifyListeners();
        Get.to(const Login(),
            transition: Transition.fade,
            curve: Curves.easeOut,
            duration: const Duration(microseconds: 800));
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
      }
    } catch (e) {
      final res = json.decode(req.body);
      _isLoading = false;
      _reqMessage = res['status'];
      notifyListeners();
    }
  }

  void login({required String phone, required String password}) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.login;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8'
    };
    final body = {
      'phone': phone,
      'password': password,
    };

    http.Response req = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (req.statusCode == 200 || req.statusCode == 201) {
        print(req.body);
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['status'];
        final token = res['access_token'];
        DatabaseProvider().saveToken(token);
        final id = res['user']['id'];
        DatabaseProvider().saveId(id);
        if (kDebugMode) {
          print(id);
        }
        if (kDebugMode) {
          print(token);
        }
        notifyListeners();
        Get.to(const DashboardScreen(),
            transition: Transition.fade,
            curve: Curves.easeOut,
            duration: const Duration(microseconds: 800));
      }
    } catch (e) {
      final res = json.decode(req.body);
      _isLoading = false;
      _reqMessage = res['status'];
      notifyListeners();
    }
  }

  void clear() {
    _reqMessage = '';
    notifyListeners();
  }
}
