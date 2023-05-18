import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/styles/colors.dart';

class CustomButton extends StatelessWidget {
  final String? placeholder;
  final VoidCallback? method;
  final Color? color;
  final double? width;
  final double? height;
  final IconData? icon;

  const CustomButton(
      {Key? key,
      this.placeholder,
      this.method,
      this.color,
      this.width,
      this.height,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 500,
      height: height ?? 50,
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
              CustomText(
                placeholder: placeholder!,
                fontWeight: FontWeight.bold,
                color: ilocateWhite,
                fontSize: 16,
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
