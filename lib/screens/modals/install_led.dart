import 'package:SmartShop/providers/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/screens/components/pages/led_page_view.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:SmartShop/utils/snackMessage.dart';

class LedForm extends StatefulWidget {
  const LedForm({Key? key}) : super(key: key);

  @override
  _LedFormState createState() => _LedFormState();
}

class _LedFormState extends State<LedForm> {
  List<Map<String, dynamic>>? _mcus;
  List<Map<String, dynamic>>? _pins;

  String? message;

  @override
  void initState() {
    super.initState();
    _loadLeds();
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessage() async {
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

    // Clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');

    Get.to(() => const Leds(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 100));
  }

  _loadLeds() async {
    final leds = await LedProvider().getMicroControllers();
    setState(() {
      _mcus = leds;
    });
  }

  Future<List<Map<String, dynamic>>> _loadPins(String? led) async {
    final pins = await LedProvider().getPins(led);
    return pins;
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController shelfController = TextEditingController();
  TextEditingController pinNumberController = TextEditingController();
  TextEditingController ledController = TextEditingController();

  clearInput() {
    shelfController.clear();
    pinNumberController.clear();
    ledController.clear();
  }

  _buildPinDropdown() {
    return _pins == null
        ? const Center(child: CircularProgressIndicator())
        : _pins!.isEmpty
            ? const Center(child: Text('No pins found'))
            : DropdownButtonFormField<String>(
                hint: const CustomText(placeholder: 'Select Pin'),
                value: _selectedPin,
                isExpanded: true,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPin = newValue;
                  });
                },
                items: _pins != null
                    ? _pins!.map<DropdownMenuItem<String>>((pin) {
                        return DropdownMenuItem<String>(
                          value: pin['pinNumber'].toString(),
                          child: Text(
                              'MCU ${pin['microcontroller_id']} - Pin ${pin['pinNumber']}'),
                        );
                      }).toList()
                    : [],
                validator: (value) {
                  if (value == null) {
                    return 'Please select pin';
                  }
                  return null;
                },
              );
  }

  String? _selectedLed;
  String? _selectedPin;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Form(
      key: formKey,
      child: CustomButton(
        placeholder: 'Install LED',
        width: isMobile ? 200 : 300,
        color: smartShopYellow,
        method: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    textAlign: TextAlign.center,
                    placeholder: 'Install LED',
                    color: smartShopYellow,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.lightbulb,
                    color: smartShopYellow,
                  )
                ],
              ),
              backgroundColor: smartShopLight,
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: isMobile ? null : 600,
                      child: Column(
                        children: [
                          buildDropdownButtonFormField(setState),
                          const SizedBox(height: 10),
                          _buildPinDropdown(),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Shelf Description',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            controller: shelfController,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(smartShopYellow),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var shelfNumber = shelfController.text;
                      var microControllerId = _selectedLed;
                      var pinId = _selectedPin;
                      if (await LedProvider().installLed(
                        shelfNumber,
                        microControllerId!,
                        pinId!,
                      )) {
                        _loadMessage();
                        Navigator.pop(context);
                      } else {
                        _loadMessage();
                        Navigator.pop(context);
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
                    backgroundColor: MaterialStateProperty.all(smartShopYellow),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DropdownButtonFormField<String> buildDropdownButtonFormField(
      StateSetter setState) {
    return DropdownButtonFormField<String>(
      hint: const CustomText(placeholder: 'Select MCU'),
      value: _selectedLed,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (newValue) {
        if (newValue == null) return;
        setState(() {
          _selectedLed = newValue;
          _selectedPin = null; // Reset the selected pin when the MCU changes
          _loadPins(newValue).then((pins) {
            setState(() {
              _pins = pins;
            });
          });
        });
      },
      items: _mcus != null && _mcus!.isNotEmpty
          ? _mcus!.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
              return DropdownMenuItem<String>(
                value: value['id'].toString(),
                child: CustomText(
                  placeholder: '${value['Name']} - ${value['description']}',
                ),
              );
            }).toList()
          : const [
              DropdownMenuItem<String>(
                value: 'loading',
                child: CustomText(
                  placeholder: 'Loading LEDs...',
                ),
              ),
            ],
    );
  }
}
