import 'dart:convert';

import 'package:SmartShop/utils/snackMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  Future<List<Map<String, dynamic>>> getUsers() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.users;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    try {
      http.Response req = await http.get(Uri.parse(url), headers: headers);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        print(res);

        _isLoading = false;
        notifyListeners();
        return List<Map<String, dynamic>>.from(res['data']);
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        print(res);
        notifyListeners();
        return [];
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      storeMessageToInMemory(res);
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.supplier}/search/suppliers?search=$query';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    try {
      http.Response req = await http.get(Uri.parse(url), headers: headers);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        _isLoading = false;
        notifyListeners();
        return List<Map<String, dynamic>>.from(res['data']);
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        return [];
      }
    } catch (e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
      return [];
    }
  }

  Future<bool> addSupplier({
    required String name,
    required String email,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.supplier;

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
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        if (kDebugMode) {
          print(res);
        }
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        storeMessageToInMemory(res['message']);
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
        storeMessageToInMemory(res['message']);
        return false;
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
      storeMessageToInMemory(res);
      return false;
    }
  }

  Future<bool> updateSupplier(String? name, String? email, String? address,
      String? phone, int id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.supplier}/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
    };

    try {
      http.Response req = await http.put(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        if (kDebugMode) {
          print(res);
        }
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        storeMessageToInMemory(res['message']);
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
        storeMessageToInMemory(res['message']);
        return false;
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
      storeMessageToInMemory(res);
      return false;
    }
  }

  //  delete
  Future<bool> deleteSupplier(int id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.supplier}/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    try {
      http.Response req = await http.delete(Uri.parse(url), headers: headers);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        _isLoading = false;
        storeMessageToInMemory(res['message']);
        notifyListeners();
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        storeMessageToInMemory(res['message'].toString());
        notifyListeners();
        return false;
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      storeMessageToInMemory(res);
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> getSupplier(String? id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.supplier}/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization':
          'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

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
}
