import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/StocksLineChart.dart';
import 'package:ilocate/custom_widgets/out_of_stocks_table.dart';
import 'package:ilocate/providers/itemProvider.dart';
import 'package:ilocate/providers/statisticsProvider.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/styles/colors.dart';

class Stocks extends StatefulWidget {
  const Stocks({Key? key});

  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  List<Map<String, dynamic>>? _statisticsData;
  List<Map<String, dynamic>>? _outOfStocksData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStatisticsData();
    _loadOutOfStocksData();
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

  Future<void> _loadOutOfStocksData() async {
    setState(() {
      _errorMessage = null;
      _outOfStocksData = null;
    });

    try {
      final data = await ItemProvider().getItemsOutOfStock();
      _setOutOfStocksData(data);
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

  void _setOutOfStocksData(List<Map<String, dynamic>> data) {
    setState(() {
      _outOfStocksData = data;
    });
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
                  Text('Stocks Stats',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ilocateYellow)),
                  if (_statisticsData != null)
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: StocksLineChartWidget(
                        _statisticsData![0]['data']
                                ['component_with_their_quantity']
                            .map<Map<String, dynamic>>(
                                (item) => Map<String, dynamic>.from(item))
                            .toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null)
                    const SizedBox(
                        height: 200, child: RefreshProgressIndicator())
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
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text('Running Out',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ilocateGreen)),
                    ),
                     Icon(Icons.running_with_errors,
                        size: 64, color: ilocateRed),
                    const SizedBox(height: 16),
                    if (_outOfStocksData != null)
                      SizedBox(
                        height: 105,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            _outOfStocksData!.length.toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold, color: ilocateRed),
                          ),
                        ),
                      )
                    else if (_errorMessage == null)
                      const RefreshProgressIndicator()
                    else
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      )
                  ],
                )),
          ),
        ),
      ),
    ];

    if (isMobile) {
      return PageScaffold(
        title: 'Stocks Page',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const SizedBox(height: 16),
            Center(
              child: Text('Items Out Of Stock',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      textBaseline: TextBaseline.ideographic,
                      color: ilocateRed)),
            ),
            const OutOfStockTableWidget(),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Stocks Page',
        body: SizedBox(
          // width: double.infinity,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...cards,
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Text('Items Out Of Stock',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ilocateRed)),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                  const OutOfStockTableWidget(),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
