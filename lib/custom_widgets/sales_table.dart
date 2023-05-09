import 'package:flutter/material.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/modals/AddSale.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesTableWidget extends StatefulWidget {
  const SalesTableWidget({Key? key}) : super(key: key);

  @override
  _SalesTableWidgetState createState() => _SalesTableWidgetState();
}

class _SalesTableWidgetState extends State<SalesTableWidget> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  List<Map<String, dynamic>> _sales = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadMessage();
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();

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
  void _loadItems() async {
    final items = await SalesProvider().getSales();
    setState(() {
      _sales = items;
    });
  }

  void _onSearch(String query) async {
    final searchResults = await SalesProvider().search(query);
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
            const AddSalesForm(),
            SearchBar(onSearch: _onSearch),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: isMobile
                    ? 10
                    : (MediaQuery.of(context).size.width / 3.3) - 220,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => ilocateYellow,
                ),
                //   headingTextStyle: TextStyle(color: ilocateWhite),
                columns: [
                  DataColumn(
                    label: Text(
                      'ITEM',
                      style: TextStyle(
                        color: ilocateWhite,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'QUANTITY',
                      style: TextStyle(
                        color: ilocateWhite,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'TOTAL PRICE',
                      style: TextStyle(
                        color: ilocateWhite,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'DATE SOLD',
                      style: TextStyle(
                        color: ilocateWhite,
                      ),
                    ),
                  ),
                ],
                rows: _sales.isEmpty || _sales == null
                    ? const [
                        DataRow(
                          cells: [
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
                                child:
                                Text(item['component'] != null
                                ? item['component']['name']
                                : 'No Data')),
                            ),
                            DataCell(Text(
                              item['quantity'].toString(),
                              textAlign: TextAlign.center,
                            )),
                            DataCell(
                              SizedBox(
                                width: isMobile ? 60 : 150,
                                child: Text(
                                  '${item['total_price']} XAF',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  DateFormat('MMM d, y').format(
                                      DateTime.parse(item['created_at'])),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
              ),
            ),
          ],
        ));
  }
}
