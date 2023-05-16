import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/custom_widgets/custom_search_button.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/components/pages/ItemDetails.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/modals/add_item_form.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomText.dart';

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({Key? key}) : super(key: key);

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  List<Map<String, dynamic>> _items = [];
  String? message;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final items = await ItemProvider().getItems();
    setState(() {
      _items = items;
    });
  }

  void _onSearch(String query) async {
    final searchResults = await ItemProvider().search(query);
    setState(() {
      _items = searchResults;
    });
  }

  void _onFilter(DateTime? startDate, DateTime? endDate) async {
    final filterResults = await ItemProvider().filter(startDate, endDate);
    setState(() {
      _items = filterResults;
    });
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
        color: ilocateWhite,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _loadItems();
                  },
                  icon: Icon(Icons.refresh, color: ilocateGreen),
                ),
                !isMobile ? const MyForm(width: 200) : Container(),
              ],
            ),

            SearchBar(onSearch: _onSearch, onFilter: _onFilter),
            const Padding(padding: EdgeInsets.only(top: 15)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _items.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ilocateGreen,
                      ),
                    )
                  : DataTable(
                      columnSpacing: isMobile
                          ? 10
                          : (MediaQuery.of(context).size.width / 3.5) - 220,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => ilocateYellow,
                      ),
                      columns: [
                        DataColumn(
                          label: CustomText(
                            placeholder: 'NAME',
                            color: ilocateWhite,
                          ),
                        ),
                        DataColumn(
                          label: CustomText(
                            placeholder: 'DESCRIPTION',
                            color: ilocateWhite,
                          ),
                        ),
                        DataColumn(
                          label: CustomText(
                            placeholder: 'STATUS',
                            color: ilocateWhite,
                          ),
                        ),
                        DataColumn(
                          label: CustomText(
                            placeholder: 'ACTIONS',
                            color: ilocateWhite,
                          ),
                        ),
                      ],
                      rows: _items.map((item) {
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
                                  placeholder: item['description'].toString(),
                                ))),
                            DataCell(
                              Container(
                                width: isMobile ? 50 : 150,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: item['status'].toString() == 'high'
                                      ? ilocateGreen.withOpacity(0.2)
                                      : ilocateRed.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomText(
                                    placeholder: isMobile
                                        ? (item['status'].toString() == 'high'
                                            ? 'high'
                                            : 'low')
                                        : (item['status'].toString() == 'high'
                                            ? 'In stock'
                                            : 'Out of stock'),
                                    color: item['status'] == 'high'
                                        ? ilocateGreen
                                        : ilocateRed),
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
                                            color: ilocateGreen,
                                          )
                                        : Icon(
                                            Icons.lightbulb,
                                            color: ilocateRed,
                                          ),
                                    onPressed: () {
                                      LedProvider()
                                          .showItem(
                                              item['led'] != null &&
                                                      item['led']![
                                                              'led_unique_number'] !=
                                                          null
                                                  ? item['led']![
                                                      'led_unique_number']
                                                  : '',
                                              item['led'] != null &&
                                                      item['led']!['status'] ==
                                                          'on'
                                                  ? 'off'
                                                  : 'on',
                                              item['led'] != null
                                                  ? item['led']!['id']
                                                  : 0)
                                          .then((value) {
                                        print(item['led'] != null &&
                                                item['led']![
                                                        'led_unique_number'] !=
                                                    null
                                            ? item['led']!['led_unique_number']
                                            : '');
                                        _loadItems();
                                        _loadMessage();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: ilocateYellow,
                                    ),
                                    onPressed: () {
                                      Get.to(
                                          () => ItemDetail(itemID: item['id']!),
                                          transition: Transition.rightToLeft);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: ilocateRed,
                                    ),
                                    onPressed: () async {
                                      if (await ItemProvider()
                                          .deleteItem(item['id'])) {
                                        _loadMessage();
                                      } else {
                                        _loadMessage();
                                      }
                                      setState(() async {
                                        _items =
                                            await ItemProvider().getItems();
                                      });
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
