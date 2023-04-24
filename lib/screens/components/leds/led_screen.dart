import 'package:flutter/material.dart';
import 'package:ilocate/screens/customs/custom_search_button.dart';
import 'package:ilocate/styles/colors.dart';

class LedTableWidget extends StatelessWidget {
  const LedTableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: isMobile ? 50 : 260,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => ilocateYellow,
              ),
              //   headingTextStyle: TextStyle(color: ilocateWhite),
              columns: [
                DataColumn(
                  label: Text(
                    'LEDID',
                    style: TextStyle(
                      color: ilocateWhite,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SHELF NUMBER',
                    style: TextStyle(
                      color: ilocateWhite,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'UNIQUE NUMBER',
                    style: TextStyle(
                      color: ilocateWhite,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(
                      color: ilocateWhite,
                    ),
                  ),
                ),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('0001')),
                    DataCell(Text('SHELF12')),
                    DataCell(Text('LEDSH121')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'light',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('0002')),
                    DataCell(Text('SHELF13')),
                    DataCell(Text('LEDSH122')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'light',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('0003')),
                    DataCell(Text('SHELF14')),
                    DataCell(Text('LEDSH123')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'light',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('0004')),
                    DataCell(Text('SHELF15')),
                    DataCell(Text('LEDSH124')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'light',
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
