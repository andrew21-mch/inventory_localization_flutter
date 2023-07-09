import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/providers/UserProvider.dart';
import 'package:SmartShop/providers/salesProvider.dart';
import 'package:SmartShop/responsive.dart';
import 'package:SmartShop/screens/components/pages/sales.dart';
import 'package:SmartShop/screens/components/pages/suppliers.dart';
import 'package:SmartShop/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/colors.dart';

class AddSupplierForm extends StatefulWidget {
  final String? selectedItem;
  final double? width;
  final String? placeholder;
  const AddSupplierForm(
      {Key? key, this.selectedItem, this.width, this.placeholder})
      : super(key: key);

  @override
  _AddSupplierFormState createState() => _AddSupplierFormState();
}

class _AddSupplierFormState extends State<AddSupplierForm> {
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
          duration: const Duration(seconds: 2),
        ),
      );
    });

    //  clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');

    Get.to(() => const Suppliers(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 100));
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  clearInput() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
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
          icon: Icons.add_circle,
          placeholder:  'Add Supplier',
          width: isMobile
              ? 200
              : widget.width != null
              ? widget.width!.toDouble()
              : 300,
          color: smartShopYellow,
          method: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: smartShopWhite,
                scrollable: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(placeholder: 'Add Supplier',
                            fontSize: Responsive.isMobile(context) ? 20 : 30,
                            fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                  ],
                ),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SizedBox(
                      width: isMobile ? null : 600,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'a@email.com',
                            ),
                          ),
                          TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: '67287....',
                            ),
                          ),
                          //image picker
                          const SizedBox(
                            height: 10,
                          ),


                        ],
                      ),
                    );
                  },
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
                        if (formKey.currentState!.validate()) {

                          if (await UserProvider().addSupplier(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text
                          )) {
                            _loadMessageAndCloseModal();
                            Navigator.of(context).pop();
                          } else {
                            _loadMessageAndCloseModal();
                            Navigator.of(context).pop();
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
