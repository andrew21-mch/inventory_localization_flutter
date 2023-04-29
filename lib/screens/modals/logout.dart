import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ilocate/main.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:provider/provider.dart';

import '../../providers/authProvider.dart';

class LogoutModal extends StatefulWidget {
  const LogoutModal({Key? key}) : super(key: key);

  @override
  _LogoutModalState createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: CupertinoAlertDialog(
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
                color: ilocateYellow,
              ),
            ),
            onPressed: () async {
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  try {
                    DatabaseProvider().logout(context);
                  //  navigate back to login page
                    return const Login();
                  } catch (e) {
                    print('Error logging out: $e');
                  }

                  return Container();
                }
              );

              setState(() {
                _isLoading = false;
              });

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Get.to(
                  () => const Login(),
                  transition: Transition.fade,
                  curve: Curves.easeOut,
                  duration: const Duration(microseconds: 800),
                );
              });
            },
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
      ),
    );
  }
}
