import 'package:flutter/material.dart';
import 'package:ilocate/screens/customs/button.dart';

import '../../styles/colors.dart';

class LedForm extends StatefulWidget {
  const LedForm({Key? key}) : super(key: key);

  @override
  _LedFormState createState() => _LedFormState();
}

class _LedFormState extends State<LedForm> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return CustomButton(
      placeholder: 'Install LED',
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
                  children: const [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Shelf Number',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Unique ID',
                      ),
                    )
                    // ),
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
