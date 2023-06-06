import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/components/pages/ItemDetails.dart';
import 'package:SmartShop/screens/components/search_bar.dart';
import 'package:SmartShop/screens/modals/add_item_form.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomText.dart';

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({Key? key}) : super(key: key);

  @override
  DataTableWidgetState createState() => DataTableWidgetState();
}

class DataTableWidgetState extends State<DataTableWidget> {
  List<Map<String, dynamic>>? _items;
  String? message;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final items = await ItemProvider().getItems();
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  void _onSearch(String query) async {
    final searchResults = await ItemProvider().search(query);
    if(mounted){
      setState(() {
        _items = searchResults;
      });
    }
  }

  void _onFilter(DateTime? startDate, DateTime? endDate) async {
    final filterResults = await ItemProvider().filter(startDate, endDate);
    if(mounted) {
      setState(() {
        _items = filterResults;
      });
    }
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: smartShopWhite,
        elevation: 0,
        child: _items == null
            ? const LinearProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !isMobile
                          ? IconButton(
                              onPressed: () {
                                _loadItems();
                              },
                              icon: Icon(Icons.refresh, color: smartShopGreen),
                            )
                          : Container(),
                      !isMobile ? const MyForm(width: 200) : Container(),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  CustomSearchBar(onSearch: _onSearch, onFilter: _onFilter),
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _items!.isEmpty
                        ? RefreshProgressIndicator(
                              color: smartShopGreen,
                            )
                        : DataTable(
                      sortColumnIndex: 1,
                            columnSpacing: Responsive.isMobile(context) ? 10 : Responsive.isTablet(context) ? 20 : (MediaQuery.of(context).size.width / 4) - 250,
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => smartShopYellow,
                            ),
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
                                  placeholder: 'PRICE',
                                  color: smartShopWhite,
                                ),
                              ),
                              DataColumn(
                                label: CustomText(
                                  placeholder: 'STATUS',
                                  color: smartShopWhite,
                                ),
                              ),
                              DataColumn(
                                label: CustomText(
                                  placeholder: 'ACTIONS',
                                  color: smartShopWhite,
                                ),
                              ),
                            ],
                            rows: _items!.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: isMobile ? 60 : 150,
                                      child: CustomText(
                                        placeholder: item['name'].toString(),
                                      ),
                                    ),
                                  ),
                                  DataCell(SizedBox(
                                      width: isMobile ? 60 : 150,
                                      child: CustomText(
                                        placeholder:
                                            item['description'].toString(),
                                      ))),
                                  DataCell(SizedBox(
                                      width: isMobile ? 60 : 150,
                                      child: CustomText(
                                        placeholder:
                                        '${item['price_per_unit']} XAF'
                                      ))),
                                  DataCell(
                                    Container(
                                      width: isMobile ? 50 : 150,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: item['status'].toString() ==
                                                'high'
                                            ? smartShopGreen.withOpacity(0.2)
                                            : smartShopRed.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: CustomText(
                                          placeholder: isMobile
                                              ? (item['status'].toString() ==
                                                      'high'
                                                  ? 'high'
                                                  : 'low')
                                              : (item['status'].toString() ==
                                                      'high'
                                                  ? 'In stock'
                                                  : 'Out of stock'),
                                          color: item['status'] == 'high'
                                              ? smartShopGreen
                                              : smartShopRed),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: item['led'] != null &&
                                                  item['led']!['status'] == 'on'
                                              ? Icon(
                                                  Icons.lightbulb,
                                                  color: smartShopGreen,
                                                )
                                              : Icon(
                                                  Icons.lightbulb,
                                                  color: smartShopRed,
                                                ),
                                          onPressed: () {
                                            LedProvider()
                                                .showItem(
                                                    item['led'] != null &&
                                                            item['led']![
                                                                    'id'] !=
                                                                null
                                                        ? item['led']![
                                                            'id'].toString()
                                                        : '',
                                                    item['led'] != null &&
                                                            item['led']![
                                                                    'status'] ==
                                                                'on'
                                                        ? 'off'
                                                        : 'on',
                                                    item['led'] != null
                                                        ? item['led']!['id']
                                                        : 0)
                                                .then((value) {
                                              print(item['led'] != null &&
                                                      item['led']![
                                                              'id'] !=
                                                          null
                                                  ? item['led']![
                                                      'id']
                                                  : '');
                                              _loadItems();
                                              _loadMessage();
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: smartShopYellow,
                                          ),
                                          onPressed: () {
                                            Get.to(
                                                () => ItemDetail(
                                                    itemID: item['id']!),
                                                transition:
                                                    Transition.rightToLeft);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: smartShopRed,
                                          ),
                                          onPressed: () async {
                                            if (await ItemProvider()
                                                .deleteItem(item['id'])) {
                                              _loadMessage();
                                            } else {
                                              _loadMessage();
                                            }
                                           _loadItems();
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
              ));
  }
}
