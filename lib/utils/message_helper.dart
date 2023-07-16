import 'package:flutter/material.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

class MessageHelper {
   void loadMessage(Function(String?) setMessage) async {
    final message = await DatabaseProvider().getMessage();
    setMessage(message);

    Get.snackbar(
      'Message',
      message ?? 'Error loading message',
      snackPosition: SnackPosition.BOTTOM,
      maxWidth: 600.0,
      backgroundColor: smartShopYellow,
      duration: const Duration(seconds: 2),
    );

    // Clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');
  }
}
