import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutModal extends StatefulWidget {
  const LogoutModal({Key? key}) : super(key: key);

  @override
  _LogoutModalState createState() => _LogoutModalState();
}

class _LogoutModalState extends State<LogoutModal> {
  bool _isLoading = false;

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
                color: ilocateYellow,
              ),
            ),
            onPressed: ()  {
              setState(() {
                _isLoading = true;
              });

             DatabaseProvider().logout(context);

              setState(() {
                _isLoading = false;
              });

              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  login, (Route<dynamic> route) => false);

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
       );
  }
}
