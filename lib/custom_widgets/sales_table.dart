import 'package:SmartShop/utils/message_helper.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/components/search_bar.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../providers/salesProvider.dart';
import '../screens/modals/AddSale.dart';
import 'CustomText.dart';

class SalesTableWidget extends StatefulWidget {
  const SalesTableWidget({Key? key}) : super(key: key);

  @override
  _SalesTableWidgetState createState() => _SalesTableWidgetState();
}

class _SalesTableWidgetState extends State<SalesTableWidget> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  List<Map<String, dynamic>> _sales = [];
  String? message;

  @override
  void initState() {
    super.initState();
    _loadItems();
    // MessageHelper().loadMessage((newMessage) {
    //   _setMessage(newMessage!);
    // });
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }


  void _loadItems() async {
    final items = await SalesProvider().getSales();
    if (mounted) {
      setState(() {
        _sales = items;
      });
    }
  }

  void _onSearch(String query) async {
    final searchResults = await SalesProvider().search(query);
    if (mounted) {
      setState(() {
        _sales = searchResults;
      });
    }
  }

  void _onFilter(DateTime? from, DateTime? to) async {
    final searchResults = await SalesProvider().filterSales(from!, to!);
    setState(() {
      _sales = searchResults;
    });
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _loadItems();
                  },
                  icon: Icon(Icons.refresh, color: smartShopGreen),
                ),
                const AddSalesForm(),
              ],
            ),
            const SizedBox(height: 10),
            CustomSearchBar(onSearch: _onSearch, onFilter: _onFilter),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: isMobile
                    ? 10
                    : (MediaQuery.of(context).size.width / 3.3) - 220,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => smartShopYellow,
                ),
                //   headingTextStyle: TextStyle(color: smartShopWhite),
                columns: [
                  DataColumn(
                    label: CustomText(
                      placeholder: 'ITEM',
                      color: smartShopWhite,
                    ),
                  ),
                  DataColumn(
                    label: CustomText(
                      placeholder: 'QUANTITY',
                      color: smartShopWhite,
                    ),
                  ),
                  DataColumn(
                    label: CustomText(
                      placeholder: 'TOTAL PRICE',
                      color: smartShopWhite,
                    ),
                  ),
                  DataColumn(
                    label: CustomText(
                      placeholder: 'BOUGHT BY',
                      color: smartShopWhite,
                    ),
                  ),
                  DataColumn(
                    label: CustomText(
                        placeholder: 'DATE SOLD', color: smartShopWhite),
                  ),
                ],
                rows: _sales.isEmpty || _sales == null
                    ? const [
                        DataRow(
                          cells: [
                            DataCell(Text('No Data')),
                            DataCell(Text('No Data')),
                            DataCell(Text('No Data')),
                            DataCell(Text('No Data')),
                            DataCell(LinearProgressIndicator()),
                          ],
                        ),
                      ]
                    : _sales.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                  width: isMobile ? 60 : 150,
                                  child: CustomText(
                                      placeholder: item['component'] != null
                                          ? item['component']['name']
                                          : 'No Data')),
                            ),
                            DataCell(CustomText(
                              placeholder: item['quantity'].toString(),
                              textAlign: TextAlign.center,
                            )),
                            DataCell(
                              SizedBox(
                                width: isMobile ? 60 : 150,
                                child: CustomText(
                                  placeholder: '${item['total_price']} XAF',
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: isMobile ? 60 : 150,
                                child: CustomText(
                                  placeholder: item['buyer'] ?? 'N/A',
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: CustomText(
                                  placeholder: DateFormat('MMM d, y').format(
                                      DateTime.parse(item['created_at'])),
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
              ),
              //  add a total row
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: smartShopGreen.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    placeholder: 'Total',
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    placeholder: _sales.isEmpty || _sales == null
                        ? '0 XAF'
                        : '${_sales.map((e) => e['total_price']).reduce((value, element) => value + element)} XAF',
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
