import 'dart:convert';

import 'package:SmartShop/utils/snackMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class OutOfStockProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  Future<List<Map<String, dynamic>>> getItemsOutOfStock() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.outOfStocks;

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
        // print(res);
        notifyListeners();

        return [];
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.outOfStocks}/search/out_of_stocks?search=$query';
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

  Future<bool> restock(String itemId, String  quantity) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.restock;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    final body = {
      'component_id': itemId,
      'quantity': quantity,
    };

    try {
      http.Response req = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        _isLoading = false;
        notifyListeners();
        storeMessageToInMemory(res['message']);
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        storeMessageToInMemory(_reqMessage);
        return false;
      }
    } catch (e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      storeMessageToInMemory(_reqMessage);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> filter(DateTime from, DateTime to) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.outOfStocks}/search/sales_by_date?from=$from&to=$to';

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
      _reqMessage = res;
      notifyListeners();
      return [];
    }
  }


}
