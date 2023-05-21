import 'package:SmartShop/screens/auth/register.dart';
import 'package:SmartShop/screens/auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/authProvider.dart';
import 'package:SmartShop/screens/components/clippath.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/screens/customs/textfield.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:SmartShop/utils/snackMessage.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ClipPathWidget(),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: smartShopYellow,
                            ),
                          ),
                        ),
                      ),
                      CustomeTextField(
                        passwordField: false,
                        placeholder: 'Input Phone Number',
                        controller: phoneController,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: smartShopYellow,
                        ),
                      ),
                      CustomeTextField(
                        passwordField: true,
                        placeholder: 'Input your password',
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: smartShopYellow,
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'New User?',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  () => const Register(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  () => const PasswordReset(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (auth.reqMessage != '') {
                              showMessage(
                                context: context,
                                message: auth.reqMessage,
                              );
                              auth.clear();
                            }
                          });
                          return CustomButton(
                            width: 400,
                            method: () {
                              if (formKey.currentState!.validate()) {
                                auth.login(
                                  password: passwordController.text.trim(),
                                  phone: phoneController.text.trim(),
                                );
                                clearInput();
                              } else {
                                showMessage(
                                  type: 'error',
                                  context: context,
                                  message: 'Please fill all fields',
                                );
                              }
                            },
                            color: smartShopYellow,
                            placeholder: 'Login',
                          );
                        },
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
