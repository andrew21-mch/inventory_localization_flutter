import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/authProvider.dart';
import 'package:SmartShop/screens/auth/login.dart';
import 'package:SmartShop/screens/components/clippath.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/screens/customs/textfield.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:SmartShop/utils/snackMessage.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  clearInput() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
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
                  const ClipPathWidget(height: 130),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: ilocateYellow,
                            ),
                          ),
                        ),
                      ),
                      CustomeTextField(
                        passwordField: false,
                        placeholder: 'Name',
                        controller: nameController,
                        prefixIcon: Icon(
                          Icons.person,
                          color: ilocateYellow,
                        ),
                      ),
                      CustomeTextField(
                        passwordField: false,
                        placeholder: 'Input your email',
                        controller: emailController,
                        prefixIcon: Icon(
                          Icons.email,
                          color: ilocateYellow,
                        ),
                      ),
                      CustomeTextField(
                        passwordField: false,
                        placeholder: 'Input Phone Number',
                        controller: phoneController,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: ilocateYellow,
                        ),
                      ),
                      CustomeTextField(
                        passwordField: true,
                        placeholder: 'Input your password',
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: ilocateYellow,
                        ),
                      ),
                      CustomeTextField(
                        passwordField: true,
                        placeholder: 'Confirm your password',
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: ilocateYellow,
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
                                Get.to(
                                  () => const Login(),
                                  transition: Transition.rightToLeft,
                                );
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
                      const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
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
                                if (passwordController.text.trim() !=
                                    confirmPasswordController.text.trim()) {
                                  showMessage(
                                    type: 'error',
                                    context: context,
                                    message: 'Password does not match',
                                  );
                                  return;
                                }
                                auth.register(
                                    name: nameController.text.trim(),
                                    password: passwordController.text.trim(),
                                    passwordConfirmation:
                                        confirmPasswordController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    email: emailController.text.trim());
                                clearInput();
                              } else {
                                showMessage(
                                  type: 'error',
                                  context: context,
                                  message: 'Please fill all fields',
                                );
                              }
                            },
                            color: ilocateYellow,
                            placeholder: 'Register',
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          width: 400,
                          height: 50,
                          child: SizedBox(
                            width: 400,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                const Text(
                                  'By clicking Register, you agree to our ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
