import 'package:flutter/material.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/customs/textfield.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/styles/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  get passwordController => null;

  get emailController => null;

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
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                          placeholder: 'Input your email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black54,
                          ),
                        ),
                        const CustomeTextField(
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
                                  //forgot password screen
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
                          method: () {
                            Navigator.pushNamed(context, dashboard);
                          },
                        ),
                        // const Padding(padding: EdgeInsets.all(32))
                      ])
                    ])))));
  }
}
