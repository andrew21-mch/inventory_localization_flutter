import 'dart:convert';

import 'package:SmartShop/utils/snackMessage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/constants/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class LedProvider extends ChangeNotifier {
  late final BuildContext context;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _reqMessage = '';
  final String _failureMessage = '';
  bool _isLoading = false;

  String get reqMessage => _reqMessage;

  bool _isInstallingLed = false;

  bool get isLoading => _isLoading;

  String get failureMessage => _failureMessage;

  bool get isInstallingLed => _isInstallingLed;

  bool _isLedInstalled = false;

  bool get isLedInstalled => _isLedInstalled;

  set isLedInstalled(bool value) {
    _isLedInstalled = value;
    notifyListeners();
  }


  // setter
  set isInstallingLed(bool value) {
    _isInstallingLed = value;
    notifyListeners();
  }

  Future<bool>
  installLed(String shelfNumber, String micronControllerId, String pinId
      ) async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.leds;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'shelf_number': shelfNumber,
      'microcontroller_id': micronControllerId,
      'pin_id': pinId,
    };

    print(body);
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
        _isInstallingLed = true;
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
      _isInstallingLed = false;
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

  void updateLed({required String name,
    required int pinNumber,
    required int id,
  }) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.leds}/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      'name': name,
      'location': pinNumber,
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

  Future<List<Map<String, dynamic>>> getLeds() async {
    _isLoading = true;
    notifyListeners();
    String url = AppUrl.leds;

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
    String url = '${AppUrl.leds}/search/leds/?search=$query';

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
        storeMessageToInMemory(res['message']);
        notifyListeners();
        return [];
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      storeMessageToInMemory(res);
      notifyListeners();
      return [];
    }
  }

  Future<bool> deleteLed(int id) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.leds}/$id';

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
        _reqMessage = res['message'];
        notifyListeners();
        storeMessageToInMemory(res['message']);

        return true;
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();
        storeMessageToInMemory(res['message']);
        return false;
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      storeMessageToInMemory(res);
      return false;
    }
  }

  Future<bool> testLed(int pinNumber) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.leds}/test';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      "action": "on",
      'location': pinNumber,
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
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
        storeMessageToInMemory(res['message']);
        return false;
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      storeMessageToInMemory(res);
      return false;
    }
  }
  void clear() {
    _reqMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  Future<String>getLedTotal() async {
    var leds = await getLeds();
    return leds.length.toString();
  }


  Future<bool> showItem(String pinNumber, String status, int ledId) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.leds}/trigger';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((
          SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };
    final body = {
      "led_id": ledId,
      "action": status,
      'pinNumber': pinNumber,
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
        storeMessageToInMemory(res['message']);
        return false;
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      storeMessageToInMemory(res);
      return false;
    }
  }


//  get MCUs
  Future<List<Map<String, dynamic>>> getMicroControllers() async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.leds}/microcontrollers/get';

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
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();
      return [];
    }
  }

  // get a list of pins for a given mcuId

  Future<List<Map<String, dynamic>>>
  getPins(String? $mcuId) async {
    _isLoading = true;
    notifyListeners();
    String url = '${AppUrl.leds}/pins/load/${$mcuId}';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer ${await _prefs.then((SharedPreferences prefs) => prefs.getString('token') ?? '')}'
    };

    try {
      http.Response req = await http.get(Uri.parse(url), headers: headers);

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isLoading = false;
        notifyListeners();
        return List<Map<String, dynamic>>.from(res['data']);
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _reqMessage = res['message'];
        notifyListeners();

        print('Pins error: $_reqMessage'); // Print the error message

        return [];
      }
    } catch (e) {
      final res = e.toString();
      _isLoading = false;
      _reqMessage = res;
      notifyListeners();

      print('Pins exception: $_reqMessage'); // Print the exception message

      return [];
    }
  }



}
