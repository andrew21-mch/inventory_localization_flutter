import 'package:flutter/material.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/custom_widgets/custom_search_button.dart';
import 'package:ilocate/providers/outOfStockProvider.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/styles/colors.dart';

class OutOfStockTableWidget extends StatefulWidget {
  const OutOfStockTableWidget({Key? key}) : super(key: key);

  @override
  _OutOfStockTableWidgetState createState() => _OutOfStockTableWidgetState();
}

class _OutOfStockTableWidgetState extends State<OutOfStockTableWidget> {
  List<Map<String, dynamic>> _items = [];

  @override
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
      SearchBar(onSearch: _onSearch),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing:
              isMobile ? 10 : (MediaQuery.of(context).size.width / 3.9) - 220,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => ilocateYellow,
          ),
          //   headingTextStyle: TextStyle(color: ilocateWhite),
          columns: [
            DataColumn(
              label: Text(
                'NAME',
                style: TextStyle(
                  color: ilocateWhite,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'DESCRIPTION',
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
                'SUPPLIER PHONE',
                style: TextStyle(
                  color: ilocateWhite,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'ACTION',
                style: TextStyle(
                  color: ilocateWhite,
                ),
              ),
            ),
          ],
          rows: _items.map((item) {
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                      width: isMobile ? 60 : 100,
                      child:
                  Text(
                      item['component']!['name'].toString()),
                ),
                ),
                DataCell(
                  SizedBox(
                      width: isMobile ? 60 : 150,
                      child: Text(item['component']!['description'].toString(),
                          maxLines: 4,
                          softWrap: true,
                          style: const TextStyle())),
                ),
                DataCell(
                  SizedBox(
                      width: isMobile ? 60 : 100,
                      child: Text(item['component']!['quantity'].toString(),
                          maxLines: 4,
                          softWrap: true,
                          style: const TextStyle())),
                ),
                DataCell(
                  SizedBox(
                      width: isMobile ? 60 : 100,
                      child: Text(
                          item['supplier'] == null ||
                                  item['supplier']['phone'] == null
                              ? 'N/A'
                              : item['supplier']['phone'].toString(),
                          maxLines: 4,
                          softWrap: true,
                          style: const TextStyle())),
                ),
                const DataCell(
                  CustomSearchButton(
                    placeholder: 'Restock',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    ])
    );
  }
}
