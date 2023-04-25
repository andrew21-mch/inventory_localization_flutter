import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/styles/colors.dart';

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
          child:  Text('Yes',
            style: TextStyle(
              color: ilocateYellow,
            ),
          ),
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            // Perform the logout functionality here
            // For example:
            // await AuthService().logoutUser();

            // Simulate a delay of 2 seconds for demonstration purposes
            await Future.delayed(const Duration(seconds: 2));

            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged out successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pushReplacementNamed(login);
          },


        ),
        CupertinoDialogAction(
          child: const Text('No',
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
