import 'package:flutter/material.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/providers/statisticsProvider.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/customs/SalesLineChart.dart';
import 'package:ilocate/screens/customs/StocksLineChart.dart';
import 'package:ilocate/screens/dashboard/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/screens/modals/add_item_form.dart';
import 'package:ilocate/screens/modals/restock_form.dart';
import 'package:ilocate/styles/colors.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({Key? key});

  @override
  _AuthHomeState createState() => _AuthHomeState();
}
class _AuthHomeState extends State<AuthHome> {
  List<Map<String, dynamic>>? _statisticsData;
  List<Map<String, dynamic>>? _salesData;
  String? _loggedInUserNickname;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loggedInUserNickname = 'User';
    _loadSalesData();
    _loadStatisticsData();
  }

  Future<void> _loadStatisticsData() async {
    setState(() {
      _errorMessage = null;
      _statisticsData = null;
    });

    try {
      final data = await StatisticProvider().getGeneralStatistics();
      _setStatisticsData(data);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading statistics';
      });
    }
  }

  Future<void> _loadSalesData() async {
    setState(() {
      _errorMessage = null;
      _salesData = null;
    });

    try {
      final data = await SalesProvider().getSales();
      _setSalesData(data);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading statistics';
      });
    }
  }

  void _setStatisticsData(List<Map<String, dynamic>> data) {
    setState(() {
      _statisticsData = data;
    });
  }

  void _setSalesData(List<Map<String, dynamic>> data) {
    setState(() {
      _salesData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - 80) / 3;

    final cards2 = [
      // first card
      Expanded(
        flex: 2,
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Stocks Stats', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold,
                      color: ilocateYellow
                  )),
                  if (_statisticsData != null)
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: StocksLineChartWidget(
                        _statisticsData![0]['data']['component_with_their_quantity'].map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null)
                    const CircularProgressIndicator()
                  else
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

      // second card
      // third card
      Expanded(
        flex: 2,
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sales Stats', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold,
                      color: ilocateYellow
                  )),
                  if (_salesData != null && _salesData!.isNotEmpty) // check if _salesData is not null and has at least one item
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: SalessLineChartWidget(
                        _salesData!.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null)
                    const CircularProgressIndicator()
                  else
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),

            ),
          ),
        ),
      ),
    ];

    final cards = [
      // first card
      Expanded(
        flex: 2,
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.credit_card, size: 64, color: Colors.redAccent),
                  SizedBox(height: 16),
                  Text('XAF 400, 000'),
                  SizedBox(height: 8),
                  Text('Total Expenses'),
                ],
              ),
            ),
          ),
        ),
      ),
      // second card
      Expanded(
        flex: 2,
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  if(_statisticsData != null)
                    Icon(Icons.account_balance, size: 64, color: Colors.purpleAccent.shade700
                      //rotate the ic
                    ),
                  const SizedBox(height: 16),
                  if(_statisticsData != null)
                  Text('${_statisticsData![0]['data']['total_profit']}')
                  else
                    const CircularProgressIndicator(),

                  const SizedBox(height: 8),
                  const Text('Total Profits'),
                ],
              ),
            ),
          ),
        ),
      ),
      // third card
      Expanded(
        flex: 2,
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  const Icon(Icons.all_inbox, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  if(_statisticsData != null)
                  Text('${_statisticsData![0]['data']['total_components']}')
                  else
                    const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text('Total Items'),
                ],
              ),
            ),
          ),
        ),
      ),
      // fourth card
    ];


if (isMobile) {
      return PageScaffold(
        title: 'Dashboard',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 32, 16, 0),
                    child:  Text('Welcome to your dashboard $_loggedInUserNickname!',
                        style: TextStyle(
                            color: ilocateYellow,
                            textBaseline: TextBaseline.alphabetic)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 64, 32, 32),
                    child: const MyForm(),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 16, 32, 32),
                    child: const RestockForm(),
                  )
                ],
              ),
            ),
                   const SearchBar(),
                   const DataTableWidget(),
            const Padding(padding: EdgeInsets.all(32)),

          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Dashboard',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...cards,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...cards2,
              ],
            ),
            const SearchBar(),
            const DataTableWidget(),
            const Padding(padding: EdgeInsets.all(32)),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    MyForm(),
                    RestockForm(),
                  ]),
            ),
            const Padding(padding: EdgeInsets.all(32)),
          ],
        ),
      );
    }
  }

//   Future openDialogue(BuildContext context, isMobile) => showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           scrollable: true,
//           title: Row(
//             children: [
//               Text('Add Component',
//                   style: TextStyle(
//                       color: ilocateYellow,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold)),
//               const SizedBox(width: 10),
//               const Icon(Icons.add_circle_outline)
//             ],
//           ),
//           backgroundColor: ilocateLight,
//           content: SingleChildScrollView(
//             child: SizedBox(
//               width: isMobile ? null : 600,
//               child: Column(
//                 children: [
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Item Name',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Description',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Bought At',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Selling At',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Quantity',
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     // set a width
//                     isExpanded: true,
//                     value: 'Supplier A',
//                     icon: const Icon(Icons.arrow_downward),
//                     iconSize: 24,
//                     elevation: 16,
//                     style: const TextStyle(color: Colors.deepPurple),
//                     underline: Container(
//                       height: 2,
//                       color: Colors.deepPurpleAccent,
//                     ),
//                     onChanged: (String? newValue) {},
//                     items: <String>[
//                       'Supplier A',
//                       'Supplier B',
//                       'Supplier C',
//                       'Supplier D'
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   //   select supplier
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(ilocateYellow),
//               ),
//               child:
//                   const Text('Cancel', style: TextStyle(color: Colors.white)),
//             ),
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(ilocateYellow),
//                 ),
//                 child:
//                     const Text('Add', style: TextStyle(color: Colors.white))),
//           ],
//         ),
//       );
}
