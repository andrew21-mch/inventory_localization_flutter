import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/components/pages/led_page_view.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/utils/snackMessage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../styles/colors.dart';

class LedForm extends StatefulWidget {
  const LedForm({Key? key}) : super(key: key);

  @override
  _LedFormState createState() => _LedFormState();
}

class _LedFormState extends State<LedForm> {
  String? message;
  @override
  void initState() {
    super.initState();
    // _loadMessage();
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? 'Error loading message'),
          duration: const Duration(seconds: 2),
        ),
      );
    });

    //  clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');

    Get.to(() => const Leds(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 100));
  }
  final formKey = GlobalKey<FormState>();
  TextEditingController shelfController = TextEditingController();
  TextEditingController pinNumberController = TextEditingController();

  clearInput() {
    shelfController.clear();
    pinNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Form(
      key: formKey,
      child: CustomButton(
        placeholder: 'Install LED',
        width: isMobile ? 250 : 400,
        color: ilocateYellow,
        method: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: Row(
                children: [
                  Text('Install LED',
                      style: TextStyle(
                          color: ilocateYellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  const Icon(Icons.add_circle_outline),
                  const Icon(
                    Icons.lightbulb,
                    color: Colors.yellow,
                  )
                ],
              ),
              backgroundColor: ilocateLight,
              content: SingleChildScrollView(
                child: SizedBox(
                  width: isMobile ? null : 600,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'SHELF NUM',
                        ),
                        controller: shelfController,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'UNIQUE NUMBER',
                        ),
                        controller: pinNumberController,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(ilocateYellow),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var shelfNumber = shelfController.text;
                        var ledUniqueNumber = pinNumberController.text;
                        if (await LedProvider().installLed(
                          shelfNumber,
                          ledUniqueNumber,
                        )) {
                          _loadMessage();
                          Navigator.pop(context);
                        } else {
                          _loadMessage();
                          Navigator.pop(context);
                        }
                        clearInput();
                      } else {
                        showMessage(
                          context: context,
                          message: 'Please fill all fields',
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ilocateYellow),
                    ),
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          );
        },
      ),
    );
  }
}
