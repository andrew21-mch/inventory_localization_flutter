import 'dart:io';

import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/UserProvider.dart';
import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/screens/dashboard/dashboard.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:SmartShop/utils/snackMessage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyForm extends StatefulWidget {
  final int? width;
  final int? id;
  const MyForm({Key? key, this.width, this.id}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _leds = [];
  String? message;
  File? _image;
  String? _imagePath;

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  _filePickerForDesktop(StateSetter setState) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
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

    Get.to(() => const DashboardScreen(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 100));
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController uniqueIdentifierController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController pinNumberController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //image picker

  clearInput() {
    nameController.clear();
    uniqueIdentifierController.clear();
    costPriceController.clear();
    sellingPriceController.clear();
    quantityController.clear();
    pinNumberController.clear();
    supplierController.clear();
    descriptionController.clear();
  }

  String? selectedSupplier;
  String? _selectedLed;

  Future<void> _loadSuppliers() async {
    final items = await UserProvider().getUsers();
    if (mounted) {
      setState(() {
        _suppliers = items;
      });
    }
  }

  Future<void> _loadLeds() async {
    final leds = await LedProvider().getLeds();
    if (mounted) {
      setState(() {
        _leds = leds;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _loadLeds();
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
          icon: widget.id != null ? Icons.edit : Icons.add_circle,
          placeholder: widget.id != null ? '' : 'Add',
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
                    widget.id != null
                        ? const Icon(Icons.edit)
                        : const Icon(Icons.add_circle_outline),
                    Text(widget.id != null ? 'Edit' : 'Add',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            overflow: TextOverflow.ellipsis,
                            color: smartShopYellow,
                            fontSize: Responsive.isMobile(context) ? 20 : 30,
                            fontWeight: FontWeight.bold)),
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
                              hintText: 'Item Name',
                            ),
                          ),
                          TextFormField(
                            controller: uniqueIdentifierController,
                            decoration: const InputDecoration(
                              hintText: 'UNIQUE ID',
                            ),
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              hintText: 'Description',
                            ),
                          ),
                          TextFormField(
                            controller: costPriceController,
                            decoration: const InputDecoration(
                              hintText: 'Bought At',
                            ),
                          ),
                          TextFormField(
                            controller: sellingPriceController,
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
                          //image picker
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: smartShopYellow),
                              borderRadius: BorderRadius.circular(5),
                              color: smartShopWhite,
                            ),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              CustomText(placeholder: 'Select Image', color: smartShopYellow, fontSize: 20, fontWeight: FontWeight.bold,),
                              _image == null
                                  ? const SizedBox()
                                  : IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                      tooltip: 'Delete Image',
                                    ),
                              const SizedBox(
                                width: 10,
                              ),

                              IconButton(
                                icon: const Icon(Icons.image),
                                onPressed: () {
                                  _filePickerForDesktop(setState);
                                },
                                tooltip: 'Pick Image',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              //  preivew the image here
                              _image == null
                                  ? SizedBox(
                                      width: Responsive.isMobile(context)
                                          ? 100
                                          : 200,
                                      height: Responsive.isMobile(context)
                                          ? 100
                                          : 200,
                                      child: Icon(Icons.image),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.file(_image!),
                                    ),
                            ],
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
                              print(selectedSupplier);
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
                            hint: const Text('Select LED'),
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
                              print(_selectedLed);
                            },
                            items: _leds.isNotEmpty
                                ? _leds.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value['id'].toString(),
                                      child: Text('LED- ${value['id'].toString()} -MCU ${value['microcontroller']!['Name'] + ' - Pin ' + value['pin']['pinNumber'].toString()}'),
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

                          // upload image to local storage
                          if (_image != null) {
                            //get the url of the image

                            _imagePath = await DatabaseProvider().uploadImageToLocalStorage(
                              imageFile: _image!,
                            );
                          }


                          if (await ItemProvider().addItem(
                            name: nameController.text,
                            uniqueIdentifier: uniqueIdentifierController.text,
                            description: descriptionController.text,
                            cost: costPriceController.text,
                            price: sellingPriceController.text,
                            quantity: quantityController.text,
                            location: _selectedLed!,
                            supplierId: selectedSupplier!,
                            imageUri: _image
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
