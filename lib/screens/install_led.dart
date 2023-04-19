import 'package:flutter/material.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../styles/colors.dart';

class LedForm extends StatefulWidget {
  const LedForm({Key? key}) : super(key: key);

  @override
  _LedFormState createState() => _LedFormState();
}

class _LedFormState extends State<LedForm> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - 80) / 3;

    return CustomButton(
      placeholder: 'Add Item',
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
                const Icon(Icons.add_circle_outline)
              ],
            ),
            backgroundColor: ilocateLight,
            content: SingleChildScrollView(
              child: SizedBox(
                width: isMobile ? null : 600,
                child: Column(
                  children: const [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'SHELF NUM',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'UNIQUE NUMBER',
                      ),
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
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(ilocateYellow),
                  ),
                  child:
                      const Text('Add', style: TextStyle(color: Colors.white))),
            ],
          ),
        );
      },
    );
  }
}
