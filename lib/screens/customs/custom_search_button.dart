import 'package:flutter/material.dart';
import 'package:ilocate/styles/colors.dart';

class CustomSearchButton extends StatelessWidget {
  final String? placeholder;

  const CustomSearchButton({Key? key, this.placeholder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ilocateYellow,
        onPrimary: Colors.black,
        // minimumSize: const Size(150, 36),
        shadowColor: Colors.grey.withOpacity(0.8),
      ),
      onPressed: () {
        print(placeholder);
      },
      child: Text(placeholder!),
    );
  }
}
