import 'package:flutter/material.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/custom_widgets/custom_search_button.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/styles/colors.dart';

class OutOfStockTableWidget extends StatefulWidget {
  const OutOfStockTableWidget({Key? key}) : super(key: key);

  @override
  _OutOfStockTableWidgetState createState() => _OutOfStockTableWidgetState();
}

class _OutOfStockTableWidgetState extends State<OutOfStockTableWidget> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = ItemProvider().getItemsOutOfStock();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final items = snapshot.data!;
            return Column(children: [
              SearchBar(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: isMobile
                      ? 10
                      : (MediaQuery.of(context).size.width / 3) - 220,
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
                  rows: items.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(item['component']!['name'].toString()),
                        ),
                        DataCell(
                          SizedBox(
                              width: isMobile ? 60 : 100,
                              child: Text(
                                  item['component']['description'].toString(),
                                  maxLines: 4,
                                  softWrap: true,
                                  style: const TextStyle())),
                        ),
                        DataCell(
                          SizedBox(
                              width: isMobile ? 60 : 100,
                              child: Text(
                                  item['component']['quantity'].toString(),
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
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
