import 'package:flutter/material.dart';
import 'package:ilocate/providers/salesProvider.dart';
import 'package:ilocate/providers/statisticsProvider.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/custom_widgets/SalesLineChart.dart';
import 'package:ilocate/custom_widgets/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/custom_widgets/sales_table.dart';
import 'package:ilocate/styles/colors.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key});

  @override
  _SalesState createState() => _SalesState();
}
class _SalesState extends State<Sales> {
  List<Map<String, dynamic>>? _salesData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSalesData();
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
                  Text('Sales Stats', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold,
                      color: ilocateYellow
                  )),
                  if (_salesData != null)
                    SizedBox(
                      height: 200, // Replace with desired height
                      child: SalessLineChartWidget(
                        _salesData!.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList(),
                        animate: true,
                      ),
                    )
                  else if (_errorMessage == null)
                    const SizedBox(
                        height: 200,
                        child: CircularProgressIndicator()
                    )
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
                  const Icon(Icons.arrow_upward, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text('Total Sales'),
                  const SizedBox(height: 8),
                  if (_salesData != null)
                    SizedBox(
                      height: 127,
                      width: double.infinity,
                      child: Center( child: Text(
                        // get sum of all prices
                        '${_salesData!.map<int>((item) => item['total_price']).reduce((value, element) => value + element)} XAF',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),),
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
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: SearchBar(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Padding(padding: EdgeInsets.all(32)),
              const SalesTableWidget(),
            ],
          ),
        ),
      );
    }
  }
}
