import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

void showMessage(
    {String? message, String? type, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message!,
        style: GoogleFonts.quicksand(
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: type == 'error' ? Colors.red : ilocateYellow,
    ),
  );
}

void storeMessageToInMemory(String? message) {
  DatabaseProvider().storeMessage(message: message!);
}

reloadPage(BuildContext context) {
  Navigator.pushReplacementNamed(context, dashboard);
}
