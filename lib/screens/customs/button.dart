import 'package:flutter/material.dart';
import 'package:ilocate/styles/colors.dart';

class CustomButton extends StatelessWidget {
  final String? placeholder;

  const CustomButton({Key? key, this.placeholder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ilocateYellow,
              onPrimary: Colors.black,
              minimumSize: const Size(150, 36),
              shadowColor: Colors.grey.withOpacity(0.8),
            ),
            onPressed: () {
              print(placeholder);
            },
            child: Text(placeholder!),
          )),
    );
  }
}
