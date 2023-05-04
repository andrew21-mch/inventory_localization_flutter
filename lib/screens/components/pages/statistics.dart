import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/StocksLineChart.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/providers/statisticsProvider.dart';
import 'package:ilocate/custom_widgets/SalesLineChart.dart';
import 'package:ilocate/custom_widgets/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/screens/modals/add_item_form.dart';
import 'package:ilocate/screens/modals/restock_form.dart';
import 'package:ilocate/styles/colors.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key});

  @override
  _StatisticsState createState() => _StatisticsState();
}
class _StatisticsState extends State<Statistics> {
  List<Map<String, dynamic>>? _statisticsData;
  List<Map<String, dynamic>>? _salesData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
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
      //check if data is empty
      if (data.isEmpty) {
        setState(() {
          _errorMessage = 'No sales data';
        });
        return;
      }
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
                  if (_statisticsData != null && _errorMessage == null)
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: StocksLineChartWidget(
                        _statisticsData![0]['data']['component_with_their_quantity'].map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null || _statisticsData == null)
                    const RefreshProgressIndicator()
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
                  if (_salesData != null) // check if _salesData is not null and has at least one item
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: SalessHistogramChartWidget(
                        _salesData!.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null)
                    const RefreshProgressIndicator()
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
        title: 'Statistics',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const SizedBox(height: 16),
            const DataTableWidget(),
            const SizedBox(height: 16),
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
}
