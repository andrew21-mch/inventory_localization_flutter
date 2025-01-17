import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/providers/outOfStockProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/components/pages/stock.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/colors.dart';

class RestockForm extends StatefulWidget {
  final String? selectedItem;
  final double? width;
  final String? placeholder;
  const RestockForm({Key? key, this.selectedItem, this.width, this.placeholder})
      : super(key: key);

  @override
  _RestockFormState createState() => _RestockFormState();
}

class _RestockFormState extends State<RestockForm> {
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

    Get.to(() => const Stocks(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 100));
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  clearInput() {
    itemController.clear();
    quantityController.clear();
  }

  String? selectedItem;

  Future<void> _loadItems() async {
    final items = await ItemProvider().getItems();
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
    _loadItems();
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
          placeholder: widget.placeholder ?? 'Restock Item',
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
                    Text('Restock Items',
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
                          var itemId = selectedItem;
                          var quantity = quantityController.text;
                          if (await OutOfStockProvider()
                              .restock(itemId!, quantity!)) {
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
