import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/custom_widgets/sales_table.dart';
import 'package:SmartShop/custom_widgets/supplier_table.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Suppliers extends StatefulWidget {
  const Suppliers({Key? key});

  @override
  _SuppliersState createState() => _SuppliersState();
}

class _SuppliersState extends State<Suppliers> {
  String? message;

  @override
  void initState() {
    super.initState();
    _loadMessage();
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

    //  clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Sales Page',
      body: SizedBox(
        // width: double.infinity,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CustomText(placeholder: 'Welcome'),
                                SizedBox(height: 8),
                                CustomText(
                                    placeholder:
                                        'Manage your shop suppliers here.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const SupplierTableWidget()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
