import 'package:flutter/material.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/custom_widgets/custom_search_button.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:intl/intl.dart';

class SalesTableWidget extends StatefulWidget {
  const SalesTableWidget({Key? key}) : super(key: key);

  @override
  _SalesTableWidgetState createState() => _SalesTableWidgetState();
}

class _SalesTableWidgetState extends State<SalesTableWidget> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = SalesProvider().getSales();
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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: isMobile
                    ? 10
                    : (MediaQuery.of(context).size.width / 3) - 190,
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
                rows: items.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['component']['name'].toString())),
                      DataCell(
                          Text(item['quantity'].toString(), textAlign: TextAlign.center,)
                              ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                            DateFormat('MMM d, y')
                                .format(DateTime.parse(item['created_at'])),
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
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
