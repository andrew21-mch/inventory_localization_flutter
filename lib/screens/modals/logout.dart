import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:get/get.dart';

class LogoutModal extends StatefulWidget {
  const LogoutModal({Key? key}) : super(key: key);

  @override
  _LogoutModalState createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
  bool _isLoading = false;

  void logout() async {
    setState(() {
      _isLoading = true;
    });

     DatabaseProvider().logout(context);

    setState(() {
      _isLoading = false;
    });

    // Close the modal
    Get.back();
    Navigator.of(context).pop();

    // Display logout message using GetX
    Get.snackbar(
      'Logged Out',
      'You have been successfully logged out.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      maxWidth: 600.0,
      backgroundColor: smartShopYellow,
      colorText: Colors.white,
    );

    // Navigate to login screen
    Get.offAllNamed('login');

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Logout'),
      content: _isLoading
          ? Row(
        children: const [
          CupertinoActivityIndicator(),
          SizedBox(width: 16),
          Text('Logging out...'),
        ],
      )
          : const Text('Are you sure you want to logout?'),
      actions: [
        CupertinoDialogAction(
          child: Text(
            'Yes',
            style: TextStyle(
              color: smartShopYellow,
            ),
          ),
          onPressed: logout,
        ),
        CupertinoDialogAction(
          child: const Text(
            'No',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
