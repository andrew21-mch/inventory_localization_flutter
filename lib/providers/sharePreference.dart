import 'package:SmartShop/providers/authProvider.dart';
import 'package:SmartShop/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

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

  Future<String> getUserName() async {
    SharedPreferences value = await _prefs;
    if (value.containsKey('name')) {
      String data = value.getString('name') as String;
      return data;
    } else {
      return '';
    }
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
    AuthProvider authProvider = AuthProvider();
    authProvider.logout(context);
    final value = await _prefs;
    value.clear();
    Get.to(() => const Login(),
        transition: Transition.fadeIn,
        curve: Curves.easeOut,
        duration: const Duration(microseconds: 2000000));
  }

  void storeMessage({required String message}) {
    SharedPreferences.getInstance().then((value) {
      value.setString('message', message);
    });
  }

  Future<String> getMessage() async {
    SharedPreferences value = await _prefs;
    if (value.containsKey('message')) {
      String data = value.getString('message') as String;
      return data;
    } else {
      return '';
    }
  }

  Future<String> uploadImageToLocalStorage({required File imageFile}) async {
    // Generate a unique filename for the image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        path.extension(imageFile.path);

    try {
      // Get the app's document directory
      Directory appDir = await getApplicationDocumentsDirectory();

      // Create a new directory for storing images (if it doesn't exist)
      Directory imagesDir = Directory("${appDir.path}/images/");
      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }

      // Move the image file to the new directory
      File newImageFile = await imageFile.copy("${imagesDir.path}/$fileName");

      // Return the path to the uploaded image
      return newImageFile.path;
    } catch (e) {
      print("Error uploading image: $e");
      return null as String;
    }
  }

  getImageUrl(File file) {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        path.extension(file.path);
    return fileName;
  }
}
