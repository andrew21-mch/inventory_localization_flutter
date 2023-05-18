import 'package:SmartShop/styles/colors.dart';
import 'package:flutter/material.dart';

import 'CustomText.dart';

class CustomSearchButton extends StatelessWidget {
  final String? placeholder;

  const CustomSearchButton({Key? key, this.placeholder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ilocateYellow,
        onPrimary: Color.fromARGB(255, 253, 252, 252),
        // minimumSize: const Size(150, 36),
        shadowColor: Colors.grey.withOpacity(0.8),
      ),
      onPressed: () {
        print(placeholder);
      },
      child: CustomText(placeholder: placeholder, color: ilocateWhite),
    );
  }
}
