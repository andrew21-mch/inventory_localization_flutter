import 'package:flutter/material.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/custom_widgets/custom_search_button.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/styles/colors.dart';

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({Key? key}) : super(key: key);

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  List<Map<String, dynamic>> _items = [];

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
      children: [
        SearchBar(onSearch: _onSearch),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: isMobile
                ? 10
                : (MediaQuery.of(context).size.width / 3) - 220,
            headingRowColor: MaterialStateColor.resolveWith(
                  (states) => ilocateYellow,
            ),
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
                  'STATUS',
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
                  DataCell(Text(item['name'].toString())),
                  DataCell(
                    SizedBox(
                        width: isMobile ? 60 : 100,
                        child: Text(item['description'].toString(),
                            maxLines: 4,
                            softWrap: true,
                            style: const TextStyle())),
                  ),
                  DataCell(
                    Container(
                      width: isMobile ? 50 : 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: item['status'].toString() == 'high'
                            ? ilocateGreen.withOpacity(0.2)
                            : ilocateRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isMobile
                            ? (item['status'].toString() == 'high'
                            ? 'high'
                            : 'low')
                            : (item['status'].toString() == 'high'
                            ? 'In stock'
                            : 'Out of stock'),
                        style: TextStyle(
                          color: item['status'] == 'high'
                              ? ilocateGreen
                              : ilocateRed,
                        ),
                      ),
                    ),
                  ),
                  const DataCell(
                    CustomSearchButton(
                      placeholder: 'Find',
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        )
      ],
    )
    );
  }
}
