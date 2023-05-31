import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/custom_widgets/StocksLineChart.dart';
import 'package:SmartShop/custom_widgets/out_of_stocks_table.dart';
import 'package:SmartShop/providers/itemProvider.dart';
import 'package:SmartShop/providers/statisticsProvider.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:flutter/material.dart';

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
                  placeholder: 'Stocks Stats',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: smartShopYellow,
                ),
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
                   const SizedBox(height: 200, child: CustomText(placeholder: 'Nothing To Show',)
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

      // second card

      // third card
      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 200, // Replace with desired height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomText(
                      placeholder: 'Running Out',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: smartShopGreen,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.outlined_flag),
                    onPressed: _loadOutOfStocksData,
                  ),
                  if (_outOfStocksData != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CustomText(
                        placeholder: _outOfStocksData!.isNotEmpty ? _outOfStocksData!.length.toString() : '0',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: smartShopRed,
                      ),
                    )
                  else if (_errorMessage == null)
                    const RefreshProgressIndicator()
                  else
                    Center(child: CustomText(
                      placeholder: _errorMessage!,
                      color: Colors.red,
                    ))
                ],
              ),
            ),
          ),
        ),
      ),
    ];

// Rest of the code...

    if (isMobile) {
      return PageScaffold(
        title: 'Stocks Page',
        body: _statisticsData == null || _outOfStocksData == null ? const Center(child: RefreshProgressIndicator())
            :
        ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const SizedBox(height: 16),
            Center(
              child: CustomText(
                placeholder: 'Items Out Of Stock',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: smartShopRed,
              ),
            ),
            _statisticsData == [] ? const Center(child: RefreshProgressIndicator()) : const OutOfStockTableWidget(),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Stocks Page',
        body: _statisticsData == null || _outOfStocksData == null ? const Center(child: RefreshProgressIndicator())
            :
        ListView(
          scrollDirection: Axis.vertical,
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
                const SizedBox(height: 16),
                Column(
                  children: [
                    CustomText(
                      placeholder: 'Items Out Of Stock',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: smartShopRed,
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    _statisticsData!.isNotEmpty ? const OutOfStockTableWidget(): const Center(child: RefreshProgressIndicator()),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}
