import 'package:flutter/material.dart';
import 'package:ilocate/custom_widgets/CustomText.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/providers/statisticsProvider.dart';
import 'package:ilocate/custom_widgets/SalesLineChart.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/custom_widgets/sales_table.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key});

  @override
  _SalesState createState() => _SalesState();
}
class _SalesState extends State<Sales> {
  List<Map<String, dynamic>>? _salesData;
  List<Map<String, dynamic>>? _statisticsData;
  String? _errorMessage;
  String? message;


  @override
  void initState() {
    super.initState();
    _loadSalesData();
    _loadStatisticsData();
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

  Future<void> _loadStatisticsData() async {
    setState(() {
      _errorMessage = null;
      _statisticsData = null;
    });

    try {
      final data = await StatisticProvider().getSalesStatistics();
      _setStatisticsData(data);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading statistics';
      });
    }
  }


  void _setSalesData(List<Map<String, dynamic>> data) {
    setState(() {
      _salesData = data;
    });
  }

  void _setStatisticsData(List<Map<String, dynamic>> data) {
    setState(() {
      _statisticsData = data;
    });
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
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
                  CustomText(placeholder: 'Sales Stats',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ilocateYellow),
                  if (_salesData != null)
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: SalessHistogramChartWidget(
                        _statisticsData!.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null)
                    const SizedBox(
                        height: 200,
                        child: RefreshProgressIndicator()
                    )
                  else
                    CustomText(
                      placeholder: _errorMessage!,
                      color: Colors.red,
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
                  const Icon(Icons.arrow_upward, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const CustomText(placeholder: 'Total Sales'),
                  const SizedBox(height: 8),
                  if (_salesData != null)
                    SizedBox(
                      height: 127,
                      width: double.infinity,
                      child: Center( child: CustomText(
                        placeholder:
                        // get sum of all prices
                        '${_salesData!.map<int>((item) => item['total_price']).reduce((value, element) => value + element)} XAF',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),),
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

    if (isMobile) {
      return PageScaffold(
        title: 'Sales Page',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const SizedBox(height: 16),
            const SalesTableWidget(),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Sales Page',
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
              const SizedBox(height: 32),
              const SalesTableWidget(),
            ],
          ),
        ),
      );
    }
  }
}
