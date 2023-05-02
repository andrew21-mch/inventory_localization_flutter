import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

void showMessage({String? message, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message!,
        style: GoogleFonts.quicksand(
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor,
    ),
  );
}

void storeMessageToInMemory(String? message) {
  DatabaseProvider().storeMessage(message: message!);
}
