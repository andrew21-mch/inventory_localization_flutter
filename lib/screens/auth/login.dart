import 'package:flutter/material.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/customs/textfield.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  get passwordController => null;

  get emailController => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const ClipPathWidget(),
                  Column(children: [
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Image.asset('assets/images/logo.png',
                              width: 200,
                              height: 200,
                              color: Colors.amber,
                              fit: BoxFit.cover),
                        )),
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
                    const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    const CustomButton(
                      placeholder: 'Login',
                    ),
                  ])
                ]))));
  }
}
