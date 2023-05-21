import 'package:SmartShop/providers/outOfStockProvider.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/screens/components/search_bar.dart';
import 'package:SmartShop/styles/colors.dart';

import '../screens/modals/restock_form.dart';
import 'CustomText.dart';

class OutOfStockTableWidget extends StatefulWidget {
  const OutOfStockTableWidget({Key? key}) : super(key: key);

  @override
  _OutOfStockTableWidgetState createState() => _OutOfStockTableWidgetState();
}

class _OutOfStockTableWidgetState extends State<OutOfStockTableWidget> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final items = await OutOfStockProvider().getItemsOutOfStock();
    setState(() {
      _items = items;
    });
  }

  void _onSearch(String query) async {
    final searchResults = await OutOfStockProvider().search(query);
    setState(() {
      _items = searchResults;
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
        child: Column(children: [
          const SizedBox(height: 10),
          CustomSearchBar(onSearch: _onSearch),
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
                    placeholder: 'DESCRIPTION',
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
                    placeholder: 'SUPPLIER PHONE',
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
              rows: _items.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: isMobile ? 60 : 100,
                        child: CustomText(
                            placeholder: item['component']!['name'].toString()),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                          width: isMobile ? 60 : 150,
                          child: CustomText(
                            placeholder:
                                item['component']!['description'].toString(),
                            maxLines: 4,
                          )),
                    ),
                    DataCell(
                      SizedBox(
                          width: isMobile ? 60 : 100,
                          child: CustomText(
                            placeholder:
                                item['component']!['quantity'].toString(),
                            maxLines: 4,
                          )),
                    ),
                    DataCell(
                      SizedBox(
                          width: isMobile ? 60 : 100,
                          child: CustomText(
                            placeholder: item['supplier'] == null ||
                                    item['supplier']['phone'] == null
                                ? 'N/A'
                                : item['supplier']['phone'].toString(),
                            maxLines: 4,
                          )),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 130,
                        child: RestockForm(
                          selectedItem: item['component']['id'].toString(),
                          width: 200,
                          placeholder: 'Restock',
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ]));
  }
}
