import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/components/search_bar.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LedTableWidget extends StatefulWidget {
  const LedTableWidget({Key? key}) : super(key: key);

  @override
  LedTableWidgetState createState() => LedTableWidgetState();
}

class LedTableWidgetState extends State<LedTableWidget> {
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
    final items = await LedProvider().getLeds();
    setState(() {
      _items = items;
    });
  }

  void _onSearch(String query) async {
    final searchResults = await LedProvider().search(query);
    setState(() {
      _items = searchResults;
    });
  }

  void _onFilter(DateTime? from, DateTime? to) async {

  }

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
          const SizedBox(height: 10),
          CustomSearchBar(onSearch: _onSearch, onFilter: _onFilter),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: isMobile
                  ? 10
                  : (MediaQuery.of(context).size.width / 3) - 220,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => smartShopYellow,
              ),
              //   headingTextStyle: TextStyle(color: smartShopWhite),
              columns: [
                DataColumn(
                  label: CustomText(
                    placeholder: 'ID',
                    color: smartShopWhite,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    placeholder: 'SHELF',
                    color: smartShopWhite,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    placeholder: 'PIN_NUMBER',
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
                              CustomText(placeholder: item['id'].toString())),
                          DataCell(
                            SizedBox(
                                width: isMobile ? 60 : 100,
                                child: CustomText(
                                    placeholder:
                                        item['shelf_number'].toString(),
                                    maxLines: 4)),
                          ),
                          DataCell(
                            SizedBox(
                                width: isMobile ? 60 : 100,
                                child: CustomText(
                                  placeholder:
                                      item['led_unique_number'].toString(),
                                  maxLines: 4,
                                )),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: item['status'] == 'on'
                                      ? Icon(Icons.lightbulb,
                                          color: smartShopGreen)
                                      : Icon(Icons.lightbulb,
                                          color: smartShopRed),
                                  onPressed: () {
                                    LedProvider()
                                        .showItem(
                                            item['id'].toString(),
                                            item['status'] == 'on'
                                                ? 'off'
                                                : 'on',
                                            item['id'])
                                        .then((value) {
                                      _loadItems();
                                      _loadMessage();
                                    });
                                  },
                                ),
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
                                        _itemsFuture = LedProvider().getLeds();
                                      });
                                      _loadMessage();
                                    } else {
                                      _loadMessage();
                                      setState(() {
                                        _itemsFuture = LedProvider().getLeds();
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
