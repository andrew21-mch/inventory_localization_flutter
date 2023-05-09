import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  final String? placeholder;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText(
      {Key? key,
      this.placeholder,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.overflow,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Text(
      placeholder!,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 5,
      style: TextStyle(
        overflow: TextOverflow.fade,
        fontSize: isMobile ? 13.5 : fontSize ?? 16,
        fontWeight: fontWeight,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          color: color ?? const Color.fromARGB(255, 23, 20, 20)

      ),
    );
  }
}
