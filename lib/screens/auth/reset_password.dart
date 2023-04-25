import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/customs/textfield.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/styles/colors.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  clearInput() {
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - 80) / 3;
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Form(
                        key: formKey,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const ClipPathWidget(),
                          Column(children: [
                            Container(
                                padding: EdgeInsets.all(isMobile ? 32 : 20),
                                child: Center(
                                    child: Text(
                                  'Reset password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: isMobile ? 32 : 28,
                                      color: ilocateYellow),
                                ))),
                            const CustomeTextField(
                              passwordField: false,
                              placeholder: 'Phone number',
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 400,
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, login);
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.fromLTRB(0, 28, 0, 0)),
                            CustomButton(
                              placeholder: 'Reset',
                              color: ilocateYellow,
                              method: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pushNamed(context, dashboard);
                                }
                                else {
                                  clearInput();
                                  if (kDebugMode) {
                                    print('logging in...');
                                  }
                                }
                              },
                            ),
                            // const Padding(padding: EdgeInsets.all(32))
                          ])
                        ]))))));
  }
}
