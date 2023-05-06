import 'package:flutter/material.dart';
import 'package:ilocate/providers/UserProvider.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:ilocate/utils/snackMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _leds = [];
  String? message;

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessageAndCloseModal() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? 'Error loading message'),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    //  clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');

    _closeModalAndNavigate();
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController pinNumberController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  clearInput() {
    nameController.clear();
    costController.clear();
    priceController.clear();
    quantityController.clear();
    pinNumberController.clear();
    supplierController.clear();
    descriptionController.clear();
  }

  String? selectedSupplier;
  String? _selectedLed;

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

  _closeModalAndNavigate() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        dashboard, (Route<dynamic> route) => false);

  }
  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _loadLeds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Form(
        key: formKey,
        child: CustomButton(
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
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Item Name',
                          ),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                          ),
                        ),
                        TextFormField(
                          controller: costController,
                          decoration: const InputDecoration(
                            hintText: 'Bought At',
                          ),
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            hintText: 'Selling At',
                          ),
                        ),
                        TextFormField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                            hintText: 'Quantity',
                          ),
                        ),
                        DropdownButtonFormField(
                          hint: const Text('Select Supplier'),
                          isExpanded: true,
                          value: selectedSupplier,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (newValue) {
                            setState(() {
                              selectedSupplier = newValue;
                            });
                          },
                          items: _suppliers.isNotEmpty
                              ? _suppliers.map((value) {
                                  return DropdownMenuItem(
                                    value: value['id'].toString(),
                                    child: Text(value['name'].toString()),
                                  );
                                }).toList()
                              : [
                                  const DropdownMenuItem<String>(
                                    value: 'loading',
                                    child: Text('Loading suppliers...'),
                                  ),
                                ],
                        ),
// Add dropdown for LEDs
                        DropdownButtonFormField(
                          value: _selectedLed,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLed = newValue;
                            });
                          },
                          items: _leds.isNotEmpty
                              ? _leds.map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['id'].toString(),
                                    child: Text(
                                        value['led_unique_number'].toString()),
                                  );
                                }).toList()
                              : [
                                  const DropdownMenuItem<String>(
                                    value: 'loading',
                                    child: Text('Loading LEDs...'),
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
                      backgroundColor: MaterialStateProperty.all(ilocateYellow),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Add item to database
                          if (await ItemProvider().addItem(
                            name: nameController.text,
                            description: descriptionController.text,
                            cost: costController.text,
                            price: priceController.text,
                            quantity: quantityController.text,
                            supplierId: selectedSupplier!,
                            location: _selectedLed!,
                          )) {
                            _loadMessageAndCloseModal();

                          } else {
                            _loadMessageAndCloseModal();
                            reloadPage(context);
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
                        backgroundColor:
                            MaterialStateProperty.all(ilocateYellow),
                      ),
                      child: const Text('Add',
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            );
          },
        ));
  }
}
