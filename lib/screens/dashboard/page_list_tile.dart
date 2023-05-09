import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/CustomText.dart';

class PageListTile extends StatelessWidget {
  const PageListTile({
    Key? key,
    this.selectedPageName,
    required this.pageName,
    this.icon,
    this.iconTransform,
    this.onPressed,
  }) : super(key: key);
  final String? selectedPageName;
  final String pageName;
  final Widget? icon;
  final Matrix4? iconTransform;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;
    if (icon != null) {
      leadingWidget = iconTransform == null
          ? icon!
          : Transform(
              transform: iconTransform!,
              origin: const Offset(15,13),
              child: icon!,
            );
    } else {
      leadingWidget = Opacity(
        opacity: selectedPageName == pageName ? 1.0 : 0.0,
        child: const Icon(Icons.check),
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: CustomText(placeholder: pageName),
      onTap: onPressed,
    );
  }
}
