import 'package:flutter/material.dart';
import 'package:ilocate/providers/UserProvider.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/styles/colors.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _leds = [];

  String _selectedSupplier = '';
  String _selectedLed = '';

  Future<void> _loadSuppliers() async {
    final items = await UserProvider().getUsers();
    setState(() {
      _suppliers = items;
    });
  }

  Future<void> _loadLeds() async {
    final leds = await LedProvider().getLeds();
    setState(() {
      _leds = leds;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _loadLeds();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
          return CustomButton(
            placeholder: 'Add Component',
            width: isMobile ? 250 : 400,
            color: ilocateYellow,
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
                            value:
                            //    load the selected supplier
                            _selectedSupplier.isNotEmpty
                                ? _selectedSupplier
                                : null,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSupplier = newValue!;
                              });
                            },
                            items: _suppliers.isNotEmpty
                                ? _suppliers.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value['id'].toString(),
                                      child: Text(value['name'].toString()),
                                    );
                                  }).toList()
                                : [
                                    const DropdownMenuItem<String>(
                                      value: 'nothing',
                                      child: Text('Loading suppliers...'),
                                    ),
                                  ],
                          ),
                          // Add dropdown for LEDs
                          DropdownButton<String>(
                            // set a width
                            isExpanded: true,
                            value: _leds.isNotEmpty && _selectedLed.isNotEmpty
                                ? _selectedLed
                                : null,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged:
                                _leds.isNotEmpty ? (String? newValue) {} : null,
                            items: _leds.isNotEmpty
                                ? _leds.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value['id'].toString(),
                                      child: Text(value['led_unique_number'].toString()),
                                    );
                                  }).toList()
                                : [
                                    const DropdownMenuItem<String>(
                                      value: 'nothing',
                                      child: Text('Loading suppliers...'),
                                    ),
                                  ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ilocateYellow),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ilocateYellow),
                        ),
                        child: const Text('Add',
                            style: TextStyle(color: Colors.white))),
                  ],
                ),
              );
            },
          );
  }
}
