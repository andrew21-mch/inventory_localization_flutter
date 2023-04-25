import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/customs/textfield.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/styles/colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  clearInput() {
    phoneController.clear();
    passwordController.clear();
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
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: isMobile ? 32 : 28,
                                      color: ilocateYellow),
                                ))),
                            const CustomeTextField(
                              passwordField: false,
                              placeholder: 'Input your email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.black54,
                              ),
                            ),
                            const CustomeTextField(
                              passwordField: false,
                              placeholder: 'Input your password',
                              prefixIcon: Icon(
                                Icons.lock,
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
                                      Navigator.pushNamed(
                                          context, restPassword);
                                    },
                                    child: const Text(
                                      'Forgot Password',
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
                              placeholder: 'Login',
                              color: ilocateYellow,
                              method: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pushNamed(context, dashboard);
                                } else {
                                  if (kDebugMode) {
                                    print('error');
                                  }
                                }
                              },
                            ),
                            // const Padding(padding: EdgeInsets.all(32))
                          ])
                        ]))))));
  }
}
