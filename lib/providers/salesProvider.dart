import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ilocate/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SalesProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  void addSales({
    required int componentId,
    required int quantity,
  }) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.sales;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'component_id': componentId,
      'quantity': quantity,
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
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
      }
    } catch (e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.sales;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
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
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
      return [];
    }
  }


}