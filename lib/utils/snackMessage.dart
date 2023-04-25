import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
