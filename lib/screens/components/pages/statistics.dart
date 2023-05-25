import 'package:SmartShop/providers/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/custom_widgets/StocksLineChart.dart';
import 'package:SmartShop/providers/salesProvider.dart';
import 'package:SmartShop/providers/statisticsProvider.dart';
import 'package:SmartShop/custom_widgets/SalesLineChart.dart';
import 'package:SmartShop/custom_widgets/items_table.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:SmartShop/screens/modals/add_item_form.dart';
import 'package:SmartShop/screens/modals/restock_form.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<Map<String, dynamic>>? _statisticsData;
  List<Map<String, dynamic>>? _salesData;
  List<Map<String, dynamic>>? _salesStatisticsData;
  late DateTime _startDate;
  late DateTime _endDate;
  String? _errorMessage;
  String? message;

  @override
  void initState() {
    super.initState();
    _loadSalesData();
    _loadStatisticsData();
    _loadSalesStatisticsData();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
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

    // clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  Future<void> _loadSalesStatisticsData() async {
    setState(() {
      _errorMessage = null;
      _salesData = null;
    });

    try {
      final data = await StatisticProvider().getSalesStatistics();
      _setSalesStatisticsData(data);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading statistics';
      });
    }
  }

  void _onFilter(DateTime? from, DateTime? to) async {
    final searchResults =
        await StatisticProvider().getSalesStatisticsByDate(from!, to!);
    setState(() {
      _salesStatisticsData = searchResults;
    });
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

  void _setSalesStatisticsData(List<Map<String, dynamic>> data) {
    setState(() {
      _salesStatisticsData = data;
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
                    color: smartShopYellow,
                    fontSize: 24),
                if (_statisticsData != null && _errorMessage == null)
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

      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: CustomText(
                      placeholder: 'Sales Stats',
                      color: smartShopYellow,
                      fontSize: 24),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const CustomText(
                            placeholder: 'Filter by date',
                            textAlign: TextAlign.center,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          FractionallySizedBox(
                            widthFactor: 0.3,
                            child: GestureDetector(
                              onTap: () => _selectDate(context, true),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: _startDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(_startDate!)
                                          : ''),
                                  decoration: const InputDecoration(
                                    labelText: 'From',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FractionallySizedBox(
                            widthFactor: 0.3,
                            child: GestureDetector(
                              onTap: () => _selectDate(context, false),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: _endDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(_endDate!)
                                          : ''),
                                  decoration: const InputDecoration(
                                    labelText: 'To',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FractionallySizedBox(
                            widthFactor: 0.3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: smartShopYellow,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                onPressed: () =>
                                    _onFilter(_startDate, _endDate),
                                child: CustomText(
                                  placeholder: 'Filter',
                                  color: smartShopWhite,
                                )),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                if (_salesData !=
                    null) // check if _salesData is not null and has at least one item
                  SizedBox(
                    height: 200, // Replace with desired height
                    child: SalessHistogramChartWidget(
                      _salesStatisticsData!
                          .map<Map<String, dynamic>>(
                              (item) => Map<String, dynamic>.from(item))
                          .toList(),
                      animate: true,
                    ),
                  )
                else if (_errorMessage == null)
                  const RefreshProgressIndicator()
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
    ];

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
                const Icon(Icons.credit_card,
                    size: 64, color: Colors.redAccent),
                const SizedBox(height: 16),
                if (_statisticsData != null)
                  CustomText(
                      placeholder:
                          '${_statisticsData![0]['data']['expenditure']}' +
                              ' XAF',
                      color: smartShopYellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)
                else
                  const RefreshProgressIndicator(),
                const SizedBox(height: 8),
                const CustomText(placeholder: 'Total Expenses'),
              ],
            ),
          ),
        ),
      ),
      // second card
      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_statisticsData != null)
                  Icon(Icons.account_balance,
                      size: 64, color: Colors.purpleAccent.shade700
                      //rotate the ic
                      ),
                const SizedBox(height: 16),
                if (_statisticsData != null)
                  CustomText(
                      placeholder:
                          '${_statisticsData![0]['data']['total_profit']}'
                          ' XAF',
                      color: smartShopYellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)
                else
                  const RefreshProgressIndicator(),
                const SizedBox(height: 8),
                const CustomText(placeholder: 'Total Profits'),
              ],
            ),
          ),
        ),
      ),
      // third card
      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.all_inbox, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                if (_statisticsData != null)
                  CustomText(
                      placeholder:
                          '${_statisticsData![0]['data']['total_components']}',
                      color: smartShopYellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)
                else
                  const RefreshProgressIndicator(),
                const SizedBox(height: 8),
                const CustomText(placeholder: 'Total Items'),
              ],
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
                Expanded(
                  flex: 2,
                  child: cards[0],
                ),
                Expanded(
                  flex: 2,
                  child: cards[1],
                ),
                Expanded(
                  flex: 2,
                  child: cards[2],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: cards2[0],
                ),
                Expanded(
                  flex: 2,
                  child: cards2[1],
                ),
              ],
            ),
            const DataTableWidget(),
            const Padding(padding: EdgeInsets.all(32)),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      MyForm(),
                      RestockForm(),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(32)),
          ],
        ),
      );
    }
  }
}
