import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/providers/outOfStockProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/components/pages/stock.dart';
import 'package:ilocate/screens/customs/button.dart';
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
        child:
      CustomButton(
      placeholder: widget.placeholder ?? 'Restock Item',
      color: ilocateYellow,
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
                  backgroundColor: MaterialStateProperty.all(ilocateYellow),
                ),
                child:
                const Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() && selectedItem != null) {
                      var itemId = selectedItem;
                      var quantity = quantityController.text;
                      if(await OutOfStockProvider().restock(itemId!, quantity!)){
                        _loadItems();
                        selectedItem = null;
                        _loadMessageAndCloseModal();
                        Navigator.of(context).pop();
                        clearInput();
                      }else{
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
                    backgroundColor: MaterialStateProperty.all(ilocateYellow),
                  ),
                  child:
                  const Text('Add', style: TextStyle(color: Colors.white))),
            ],
          ),
        );
      },
      )
    );
  }
}
