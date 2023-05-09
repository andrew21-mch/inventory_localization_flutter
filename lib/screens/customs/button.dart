import 'package:flutter/material.dart';
import 'package:ilocate/styles/colors.dart';

class CustomButton extends StatelessWidget {
  final String? placeholder;
  final VoidCallback? method;
  final Color? color;
  final double? width;
  final IconData? icon;

  const CustomButton(
      {Key? key,
      this.placeholder,
      this.method,
      this.color,
      this.width,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 500,
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 36),
            shadowColor: Colors.grey.withOpacity(0.8),
            backgroundColor: color ?? ilocateYellow,
          ),
          onPressed: method,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                      placeholder!,
                      style: TextStyle(
                        // fontSize: ,
                        fontWeight: FontWeight.bold,
                        color: ilocateWhite,
                        letterSpacing: 1.5,
                      ),
                    ),
              icon != null
                  ? Icon(
                icon,
                color: ilocateWhite,
              )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
