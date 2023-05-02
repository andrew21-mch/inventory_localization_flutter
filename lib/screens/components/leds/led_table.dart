import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/custom_search_button.dart';
import 'package:ilocate/main.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LedTableWidget extends StatefulWidget {
  const LedTableWidget({Key? key}) : super(key: key);

  @override
  _LedTableWidgetState createState() => _LedTableWidgetState();
}

class _LedTableWidgetState extends State<LedTableWidget> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;
  String? message;

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
  void initState() {
    super.initState();
    _itemsFuture = LedProvider().getLeds();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return Column(
              children: [
                const SearchBar(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: isMobile
                        ? 10
                        : (MediaQuery.of(context).size.width / 3) - 210,
                    headingRowColor: MaterialStateColor.resolveWith(
                          (states) => ilocateYellow,
                    ),
                    //   headingTextStyle: TextStyle(color: ilocateWhite),
                    columns: [
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(
                            color: ilocateWhite,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'SHELF',
                          style: TextStyle(
                            color: ilocateWhite,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'PIN_NUMBER',
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
                    rows: items.isEmpty ?
                          const [
                            DataRow(
                              cells: [
                                DataCell(Text('No Data')),
                                DataCell(Text('No Data')),
                                DataCell(Text('No Data')),
                                DataCell(LinearProgressIndicator()),
                              ],
                            ),
                          ]
                        :
                    items.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item!['id'].toString())),
                          DataCell(
                            SizedBox(
                                width: isMobile ? 60 : 100,
                                child: Text(item!['shelf_number'].toString(),
                                    maxLines: 4,
                                    softWrap: true,
                                    style: const TextStyle())),
                          ),
                          DataCell(
                            SizedBox(
                                width: isMobile ? 60 : 100,
                                child: Text(item!['led_unique_number'].toString(),
                                    maxLines: 4,
                                    softWrap: true,
                                    style: const TextStyle())),
                          ),
                           DataCell(
                            Row(
                              children:  [
                                IconButton(
                                  icon: Icon(Icons.search,
                                      color: ilocateYellow),
                                  onPressed: () async {
                                    LedProvider().testLed(item['id']).then((value) {
                                      Navigator.pushNamed(context, '/leds/view', arguments: value);
                                    });
                                  },
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.edit, color: ilocateGreen),
                                  onPressed: () async {
                                    Navigator.pushNamed(context, '/leds/edit', arguments: item);
                                  },
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.delete, color: ilocateRed),
                                  onPressed: () async {
                                    if(await LedProvider().deleteLed(item['id']))
                                      {
                                        setState(() {
                                          _itemsFuture = LedProvider().getLeds();
                                        });
                                        _loadMessage();
                                      }else{
                                      _loadMessage();
                                      setState(() {
                                        _itemsFuture = LedProvider().getLeds();
                                      });
                                    }
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
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
