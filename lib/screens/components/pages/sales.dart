import 'package:SmartShop/custom_widgets/sales_table.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/providers/salesProvider.dart';
import 'package:SmartShop/providers/statisticsProvider.dart';
import 'package:SmartShop/custom_widgets/SalesLineChart.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:SmartShop/styles/colors.dart';
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
    _loadMessage();
    _loadSalesData();
    _loadStatisticsData();
  }

  Future<void> _loadSalesData() async {
    if (mounted) {
      setState(() {
        _errorMessage = null;
        _salesData = null;
      });
    }

    try {
      final data = await SalesProvider().getSales();
      _setSalesData(data);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

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

  Future<void> _loadStatisticsData() async {
    if (mounted) {
      setState(() {
        _errorMessage = null;
        _statisticsData = null;
      });
    }

    try {
      final data = await StatisticProvider().getSalesStatistics();
      _setStatisticsData(data);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _setSalesData(List<Map<String, dynamic>> data) {
    if (mounted) {
      setState(() {
        _salesData = data;
      });
    }
  }

  void _setStatisticsData(List<Map<String, dynamic>> data) {
    if (mounted) {
      setState(() {
        _statisticsData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - 80) / 3;

    final cards = [
      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                    placeholder: 'Sales Stats',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: smartShopYellow),
                if (_statisticsData != null)
                  SizedBox(
                    height: 200, // Replace with desired height
                    child: _statisticsData != null
                        ? SalesHistogramChartWidget(
                      _statisticsData!
                          .map<Map<String, dynamic>>(
                              (item) => Map<String, dynamic>.from(item))
                          .toList(),
                      animate: true,
                    )
                        : CircularProgressIndicator(), // Show a loading indicator while data is being fetched

                  )
                else if (_errorMessage == null)
                  const SizedBox(height: 200, child: RefreshProgressIndicator())
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

      // second card
      // third card
      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const CustomText(placeholder: 'Total Sales'),
                SizedBox(
                  height: 64,
                  width: 64,
                  child: IconButton(
                      onPressed: _loadSalesData,
                      icon: const Icon(Icons.monetization_on_outlined,
                          color: Colors.green, size: 48),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green.withOpacity(0.1),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )),
                ),
                const SizedBox(height: 8),
                if (_salesData != null &&
                    _errorMessage == null &&
                    _salesData!.isNotEmpty)
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Center(
                      child: CustomText(
                        placeholder:
                            // get sum of all prices
                            '${_salesData!.map<int>((item) => item['total_price']).reduce((value, element) => value + element)} XAF',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
    ];

    if (isMobile) {
      return PageScaffold(
        title: 'Sales Page',
        body: _statisticsData == null || _salesData == null ||
                _errorMessage != null
            ? const Center(child: RefreshProgressIndicator())
            :
        ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const SizedBox(height: 16),
            _salesData!.isNotEmpty ? const SalesTableWidget() : const LinearProgressIndicator(),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Sales Page',
        body: _statisticsData == null || _salesData == null ||
                _errorMessage != null
            ? const Center(child: RefreshProgressIndicator())
            :
        SizedBox(
          // width: double.infinity,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: cards[0],
                      ),
                      Expanded(
                        flex: 1,
                        child: cards[1],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _salesData!.isNotEmpty ? const SalesTableWidget() : const LinearProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
