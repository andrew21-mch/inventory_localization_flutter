import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ilocate/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  Future<List<Map<String, dynamic>>> getGeneralStatistics() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.statistics;

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
        if (res is Map<String, dynamic>) {
          // if the response is a map, wrap it in a list
          return [res];
        } else if (res is List<dynamic>) {
          // if the response is a list, return it directly
          return List<Map<String, dynamic>>.from(res);
        } else {
          // if the response is not a map or list, return an empty list
          return [];
        }
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

  Future<List<Map<String, dynamic>>> getSalesStatistics() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.salesStatistics;

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
        if (res is Map<String, dynamic>) {
          return [res]; // fix return statement
        } else if (res is List<dynamic>) {
          return List<Map<String, dynamic>>.from(res);
        }else {
          return [];
        }
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
