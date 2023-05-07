import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/StocksLineChart.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/providers/statisticsProvider.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/custom_widgets/SalesLineChart.dart';
import 'package:ilocate/custom_widgets/items_table.dart';
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
    _loadSalesData();
    _loadStatisticsData();
    _loadLoggedInUserName();
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

  void _setLoggedInUserName(String name) {
    setState(() {
      _loggedInUserNickname = name;
    });
  }

  Future<void> _loadLoggedInUserName() async {
    final name = await DatabaseProvider().getUserName();
    _setLoggedInUserName(name);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - 80) / 3;

    final cards = [
      // first card
      Expanded(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Welcome, $_loggedInUserNickname'),
                        const SizedBox(height: 8),
                        const Text('Here, you can view your statistics and manage your inventory.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

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
                children:  [
                  const Icon(Icons.credit_card, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  if(_statisticsData != null)
                    Text('${_statisticsData![0]['data']['total_profit']}' + ' XAF', style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: ilocateYellow
                    ))
                  else
                    const RefreshProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text('Total Expenses'),
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
                    Text('${_statisticsData![0]['data']['total_profit']}' + ' XAF', style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: ilocateYellow
                    ))
                  else
                    const RefreshProgressIndicator(),

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
                    Text('${_statisticsData![0]['data']['total_components']}', style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: ilocateYellow
                    ))
                  else
                    const RefreshProgressIndicator(),
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
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.fromLTRB(8, 32, 32, 32),
                    child: Text(
                        'Welcome to your dashboard $_loggedInUserNickname!\nHere, you can view your statistics and manage your inventory.',
                        style: TextStyle(
                            color: ilocateBlue,
                            textBaseline: TextBaseline.alphabetic)),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    margin: const EdgeInsets.fromLTRB(8, 64, 32, 32),
                    child: const MyForm(),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 16, 32, 32),
                    child: const RestockForm(width: 200),
                  )
                ],
              ),
            ),

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
            const DataTableWidget(),
            Expanded(
              child:
              Card(

              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(padding: EdgeInsets.all(32)),
                    MyForm(),
                    RestockForm(),
                    Padding(padding: EdgeInsets.all(32)),

                  ]),
            ),),
          ],
        ),
      );
    }
  }
}
