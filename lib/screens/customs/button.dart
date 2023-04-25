import 'package:flutter/material.dart';
import 'package:ilocate/styles/colors.dart';

class CustomButton extends StatelessWidget {
  final String? placeholder;
  final VoidCallback? method;
  final Color? color;
  final double? width;

  const CustomButton({Key? key, this.placeholder, this.method, this.color, this.width})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SizedBox(
      width:  width ?? 400,
      child: Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: isMobile ? color : ilocateYellow,
              onPrimary: Colors.black,
              minimumSize: const Size(150, 36),
              shadowColor: Colors.grey.withOpacity(0.8),
            ),
            onPressed: method,
            child: Text(
              placeholder!,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          )),
    );
  }
}
