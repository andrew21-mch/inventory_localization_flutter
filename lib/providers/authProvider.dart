import 'dart:convert';
import 'dart:io';

import 'package:SmartShop/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/auth/login.dart';
import 'package:SmartShop/screens/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  void register(
      {required String name,
      required String email,
      required String password,
      required String passwordConfirmation,
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
      'password_confirmation': passwordConfirmation,
      'phone': phone,
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        Future.delayed(const Duration(seconds: 2), () {
          Get.to(
            () => const Login(),
            transition: Transition.fade,
            curve: Curves.easeOut,
            duration: const Duration(microseconds: 800),
          );
        });
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage =
          '$res Check to make sure you connected to the same server as the server';
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

    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        final token = res['access_token'];
        DatabaseProvider().saveToken(token);
        final id = res['user']['id'];
        DatabaseProvider().saveId(id);
        DatabaseProvider().saveUserName(res['user']['name']);
        notifyListeners();
        Future.delayed(const Duration(seconds: 2), () {
          Get.to(
            () => const DashboardScreen(),
            transition: Transition.fade,
            curve: Curves.easeOut,
            duration: const Duration(microseconds: 800),
          );
        });
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage =
          '$res Check to make sure you connected to the same server as the server';
      notifyListeners();
    }
  }

  Future<bool> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.logout;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    http.Response req = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(''));

    try {
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      final res = json.decode(req.body);
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      return false;
    }
  }

  void resetPassword({required String phone}) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.resetPassword;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8'
    };
    final body = {
      'phone': phone,
    };

    http.Response req = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    try {
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        Get.to(
          () => const Login(),
          transition: Transition.fade,
          curve: Curves.easeOut,
          duration: const Duration(microseconds: 800),
        );
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
      }
    } catch (e) {
      final res = json.decode(req.body);
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
    }
  }

  void clear() {
    _reqMessage = '';
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    final token = await DatabaseProvider().getToken();
    if (token == '') {
      return false;
    } else {
      return true;
    }
  }

//  check Connection AppUrl
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.baseUrl));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      storeMessageToInMemory(
          '$e Check that you are connected to the same server as the server');
      return false;
    }
  }

//  get user profile
  Future<Map<String, dynamic>> getProfile() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    String url = AppUrl.profile;

    try {
      http.Response req = await http.get(Uri.parse(url), headers: headers);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        _isLoading = false;
        notifyListeners();
        return res['data'];
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        return {};
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      storeMessageToInMemory(res);
      notifyListeners();
      return {};
    }
  }

//  update user profile
  Future<List<Map<String, dynamic>>> updateProfile(
      String? name, String? email, String? phone, File? image) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image != null ? base64Encode(await image.readAsBytes()) : null
    };

    http
        .put(Uri.parse(AppUrl.profile),
            headers: headers, body: json.encode(body))
        .then((value) {
      final res = json.decode(value.body);
      return res['data'];
    }).catchError((e) {
      return [];
    });

    return [];
  }

//  update Password
  Future<bool> updatePassword(
    String? oldPassword,
    String? newPassword,
    String? newPasswordConfirm,
  ) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      "old_password": oldPassword,
      'password': newPassword,
      'password_confirmation': newPasswordConfirm,
    };
    http
        .put(Uri.parse(AppUrl.updatePassword),
            headers: headers, body: json.encode(body))
        .then((value) {
      final res = json.decode(value.body);
      storeMessageToInMemory(res['message']);
      return true;
    }).catchError((e) {
      storeMessageToInMemory(e.toString());
      return false;
    });

    storeMessageToInMemory('Something went wrong');
    notifyListeners();
    return false;
  }
}
