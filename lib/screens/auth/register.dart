import 'package:flutter/material.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/customs/textfield.dart';
import 'package:ilocate/styles/colors.dart';

import '../customs/button.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  get passwordController => null;

  get emailController => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const ClipPathWidget(),
                      Column(children: [
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Image.asset('assets/images/logo.png',
                                  width: 150,
                                  height: 150,
                                  color: ilocateYellow,
                                  fit: BoxFit.cover),
                            )),
                        const CustomeTextField(
                          placeholder: 'Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black54,
                          ),
                        ),
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
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  //forgot password screen
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
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                        const CustomButton(
                          placeholder: 'Register',
                        ),
                      ])
                    ])))));
  }
}
