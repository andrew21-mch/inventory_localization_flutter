import 'package:flutter/material.dart';

class CustomeTextField extends StatelessWidget {
  final String? placeholder;
  final Widget? prefixIcon;

  const CustomeTextField({Key? key, this.placeholder, this.prefixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 3),
              blurRadius: 10.0,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: placeholder,
            labelStyle: const TextStyle(color: Colors.black54),
            prefixIcon: prefixIcon,
          ),
        ),
      ),
    );
  }
}
