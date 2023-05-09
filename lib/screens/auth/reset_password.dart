import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ilocate/providers/authProvider.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/customs/textfield.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:ilocate/utils/snackMessage.dart';
import 'package:provider/provider.dart';

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

    return ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: Scaffold(
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
                              keyboardType: TextInputType.phone,
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
                                      Get.to(() => const Login(),
                                        transition: Transition.rightToLeft

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
                            const Padding(
                                padding: EdgeInsets.fromLTRB(0, 28, 0, 0)),
                            Consumer<AuthProvider>(
                              builder: (context, auth, child) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
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
                                    //check if its valid phone number
                                    if (phoneController.text.trim().length !=
                                        9) {
                                      showMessage(
                                        type: 'error',
                                        context: context,
                                        message:
                                            'Please enter a valid phone number',
                                      );
                                      return;
                                    }
                                    if (formKey.currentState!.validate()) {
                                      auth.resetPassword(
                                        phone: phoneController.text.trim(),
                                      );
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
                            // const Padding(padding: EdgeInsets.all(32))
                          ])
                        ]))))));
  }
}
