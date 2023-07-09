import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/providers/UserProvider.dart';
import 'package:SmartShop/screens/modals/AddSale.dart';
import 'package:SmartShop/screens/modals/add_supplier_form.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/components/search_bar.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierTableWidget extends StatefulWidget {
  const SupplierTableWidget({Key? key}) : super(key: key);

  @override
  SupplierTableWidgetState createState() => SupplierTableWidgetState();
}

class SupplierTableWidgetState extends State<SupplierTableWidget> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  List<Map<String, dynamic>> _items = [];
  String? message;

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: smartShopYellow,
        ),
      );
    });

    //  clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final items = await UserProvider().getUsers();
    setState(() {
      _items = items;
    });
  }

  void _onSearch(String query) async {
    final searchResults = await UserProvider().search(query);
    setState(() {
      _items = searchResults;
    });
  }

  void _onFilter(DateTime? from, DateTime? to) async {}

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Column(
        children: [
          const SizedBox(height: 32),
          const AddSupplierForm(),
          const SizedBox(height: 10),
          CustomSearchBar(onSearch: _onSearch, onFilter: _onFilter),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing:
                  isMobile ? 10 : (MediaQuery.of(context).size.width / 3) - 220,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => smartShopYellow,
              ),
              //   headingTextStyle: TextStyle(color: smartShopWhite),
              columns: [
                DataColumn(
                  label: CustomText(
                    placeholder: 'NAME',
                    color: smartShopWhite,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    placeholder: 'PHONE NUMBER',
                    color: smartShopWhite,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    placeholder: 'EMAIL',
                    color: smartShopWhite,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    placeholder: 'ACTION',
                    color: smartShopWhite,
                  ),
                ),
              ],
              rows: _items.isEmpty
                  ? const [
                      DataRow(
                        cells: [
                          DataCell(CustomText(placeholder: 'No Data')),
                          DataCell(CustomText(placeholder: 'No Data')),
                          DataCell(CustomText(placeholder: 'No Data')),
                          DataCell(LinearProgressIndicator()),
                        ],
                      ),
                    ]
                  : _items.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                              CustomText(placeholder: item['name'].toString())),
                          DataCell(
                            SizedBox(
                                width: isMobile ? 60 : 100,
                                child: CustomText(
                                    placeholder: item['phone'].toString(),
                                    maxLines: 4)),
                          ),
                          DataCell(
                            SizedBox(
                                width: isMobile ? 60 : 100,
                                child: CustomText(
                                  placeholder: item['email'].toString(),
                                  maxLines: 4,
                                )),
                          ),
                          DataCell(
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.edit, color: smartShopGreen),
                                  onPressed: () async {
                                    Navigator.pushNamed(context, '/leds/edit',
                                        arguments: item);
                                  },
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.delete, color: smartShopRed),
                                  onPressed: () async {
                                    if (await LedProvider()
                                        .deleteLed(item['id'])) {
                                      setState(() {
                                        _itemsFuture =
                                            UserProvider().getUsers();
                                      });
                                      _loadMessage();
                                    } else {
                                      _loadMessage();
                                      setState(() {
                                        _itemsFuture =
                                            UserProvider().getUsers();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
            ),
          )
        ],
      ),
    );
  }
}