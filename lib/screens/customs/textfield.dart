import 'package:flutter/material.dart';

class CustomeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final Widget? prefixIcon;
  final bool passwordField;
  final TextInputType? keyboardType;


  const CustomeTextField({Key? key, this.placeholder, this.prefixIcon, required this.passwordField, this.controller, this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
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
        child: TextFormField(
          obscureText: passwordField ? true: false,
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value!.isEmpty) {
              // style the error message
              var errorMessage = 'Please $placeholder';
              return errorMessage;
            }
            return null;
          },
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
