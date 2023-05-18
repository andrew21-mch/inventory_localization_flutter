import 'dart:convert';

import 'package:SmartShop/utils/snackMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ItemProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  Future<bool> addItem({required String name,
    required String description,
    required String price,
    required String quantity,
    required String cost,
    required String location,
    required String supplierId,

  }) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.items;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'price_per_unit': cost, // 'cost' is 'price_per_unit
      'location': location,
      'supplier_id': supplierId,
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
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
      storeMessageToInMemory(res['message']);
      return false;
    }
  }

  Future<bool>
  updateItem( String name,
     String description,
     String price,
     String quantity,
     String cost,
     String location,
     String supplierId,
     String id,

  ) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.items}/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'cost': cost,
      'location': location,
      'supplier_id': supplierId,
    };

    print(body);

    try {
      http.Response req = await http.put(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        if (kDebugMode) {
          print(res);
        }
        _isLoading = false;
        storeMessageToInMemory(res['message']);
        notifyListeners();
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        storeMessageToInMemory(res['message']);
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
        return false;
      }
    } catch (e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }

      storeMessageToInMemory(res['message']);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.items;

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

  Future<Map<String, dynamic>> getItem(String? id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.items}/$id';


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
      //  print data type
        print(res.runtimeType);
        return res['data'];
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        print(res);
        notifyListeners();

        return {};
      }
    } catch (e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      return {};
    }
  }


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
        // print(res);

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
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.items}/search/component?search=$query';
    print(query);

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

//  delete
  Future<bool> deleteItem(int id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.items}/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    try {
      http.Response req = await http.delete(Uri.parse(url), headers: headers);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        _isLoading = false;
        storeMessageToInMemory(res['message']);
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        storeMessageToInMemory(res['errors'].toString());
        notifyListeners();
        if (kDebugMode) {
          print(res);
        }
        return false;
      }
    } catch (e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      storeMessageToInMemory(res);
      notifyListeners();
      if (kDebugMode) {
        print(res);
      }
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getItemsBySupplier(int id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.items}/supplier/$id';

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
        _reqMessage = res['error'];
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

  Future<List<Map<String, dynamic>>> filter(DateTime? startDate, DateTime? endDate) {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.items}/filter?start_date=$startDate&end_date=$endDate';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${_prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    http.get(Uri.parse(url), headers: headers).then((http.Response req) {
      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        _isLoading = false;
        notifyListeners();
        print(res);
        return List<Map<String, dynamic>>.from(res['data']);
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        return [];
      }
    }).catchError((e) {
      final res = json.decode(e.toString());
      _isLoading = false;
      _reqMessage = res['message'];
      notifyListeners();
      return [];
    });

    return Future.value([]);
  }

}
