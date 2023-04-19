import 'package:flutter/material.dart';
import 'package:ilocate/screens/customs/custom_search_button.dart';
import 'package:ilocate/styles/colors.dart';

class DataTableWidget extends StatelessWidget {
  const DataTableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: isMobile ? 50 : 290,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => ilocateYellow,
              ),
              //   headingTextStyle: TextStyle(color: ilocateWhite),
              columns: [
                DataColumn(
                  label: Text(
                    'ITEMID',
                    style: TextStyle(
                      color: ilocateWhite,
                    ),
                  ),
                ),
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
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('Item 1')),
                    DataCell(Text('Name 1')),
                    DataCell(Text('Status 1')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Item 2')),
                    DataCell(Text('Name 2')),
                    DataCell(Text('Status 2')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Item 3')),
                    DataCell(Text('Name 3')),
                    DataCell(Text('Status 3')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Item 4')),
                    DataCell(Text('Name 4')),
                    DataCell(Text('Status 4')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Item 5')),
                    DataCell(Text('Name 5')),
                    DataCell(Text('Status 5')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Item 6')),
                    DataCell(Text('Name 6')),
                    DataCell(Text('Status 6')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Item 7')),
                    DataCell(Text('Name 7')),
                    DataCell(Text('Status 7')),
                    DataCell(
                      CustomSearchButton(
                        placeholder: 'Find',
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
