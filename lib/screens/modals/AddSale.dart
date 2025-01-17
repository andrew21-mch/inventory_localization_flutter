import 'package:SmartShop/providers/salesProvider.dart';
import 'package:SmartShop/screens/components/pages/sales.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/colors.dart';

class AddSalesForm extends StatefulWidget {
  final String? selectedItem;
  final double? width;
  final String? placeholder;
  const AddSalesForm(
      {Key? key, this.selectedItem, this.width, this.placeholder})
      : super(key: key);

  @override
  _AddSalesFormState createState() => _AddSalesFormState();
}

class _AddSalesFormState extends State<AddSalesForm> {
  List<Map<String, dynamic>> _items = [];
  String? message;

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessageAndCloseModal() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    // Display message using GetX snackbar
    Get.snackbar(
      'Message',
      message ?? 'Error loading message',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    // Clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');

    Get.to(() => const Sales(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 100));
  }


  final formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController buyerController = TextEditingController();

  clearInput() {
    itemController.clear();
    quantityController.clear();
    buyerController.clear();
  }

  String? selectedItem;

  Future<void> _loadItems() async {
    final items = await ItemProvider().getItems();
    setState(() {
      _items = items;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
    _loadItems();
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
          placeholder: widget.placeholder ?? 'Add Sale',
          icon: Icons.add_circle_outline,
          color: smartShopYellow,
          width: widget.width ?? 200,
          method: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                scrollable: true,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Sell',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: smartShopYellow,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    const Icon(Icons.add_circle_outline)
                  ],
                ),
                backgroundColor: smartShopLight,
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: isMobile ? 200 : 600,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          hint: const Text('Select Item'),
                          isExpanded: true,
                          value: selectedItem,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (newValue) {
                            setState(() {
                              selectedItem = newValue;
                            });
                          },
                          items: _items.isNotEmpty
                              ? _items.map((value) {
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
                        TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter quantity';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Quantity',
                          ),
                        ),

                        TextFormField(
                          controller: buyerController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Buyer Name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Buyer name',
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
                      backgroundColor:
                          MaterialStateProperty.all(smartShopYellow),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate() &&
                            selectedItem != null) {
                          var componentId = selectedItem;
                          var quantity = quantityController.text;
                          var buyer = buyerController.text;
                          if (await SalesProvider()
                              .addSales(componentId, quantity, buyer)) {
                            _loadItems();
                            selectedItem = null;
                            _loadMessageAndCloseModal();
                            Navigator.of(context).pop();
                            clearInput();
                          } else {
                            _loadItems();
                            selectedItem = null;
                            clearInput();
                            _loadMessageAndCloseModal();
                            Navigator.of(context).pop();
                          }
                        } else {
                          _loadMessageAndCloseModal();
                          Navigator.of(context).pop();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(smartShopYellow),
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
