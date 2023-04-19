import 'package:flutter/material.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../styles/colors.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Add Component',
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
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
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Item Name',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Bought At',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Selling At',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                      ),
                    ),
                    DropdownButton<String>(
                      // set a width
                      isExpanded: true,
                      value: 'Supplier A',
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {},
                      items: <String>[
                        'Supplier A',
                        'Supplier B',
                        'Supplier C',
                        'Supplier D'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      // set a width
                      isExpanded: true,
                      value: 'LED100',
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {},
                      items: <String>[
                        'LED100',
                        'LED101',
                        'LED102',
                        'LED102',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // ElevatedButton(
                    //   onPressed: getImage,
                    //   child: const Text('Pick Image'),
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
