import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/providers/salesProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/providers/statisticsProvider.dart';
import 'package:SmartShop/custom_widgets/items_table.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:SmartShop/screens/modals/add_item_form.dart';
import 'package:SmartShop/screens/modals/restock_form.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key});

  @override
  AuthHomeState createState() => AuthHomeState();
}

class AuthHomeState extends State<AuthHome> {
  List<Map<String, dynamic>>? _statisticsData;
  List<Map<String, dynamic>>? _salesData;
  String? _loggedInUserNickname;
  String? _errorMessage;
  String? message;

  @override
  void initState() {
    super.initState();
    _loadMessage();
    _loadSalesData();
    _loadStatisticsData();
    _loadLoggedInUserName();
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  Future<void> _loadStatisticsData() async {
    setState(() {
      _errorMessage = null;
      _statisticsData = null;
    });

    try {
      final data = await StatisticProvider().getGeneralStatistics();
      _setStatisticsData(data);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
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
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
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
                        CustomText(
                            placeholder: 'Welcome, $_loggedInUserNickname'),
                        const SizedBox(height: 8),
                        const CustomText(
                            placeholder:
                                'Here, you can view your statistics and manage your inventory.'),
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
                children: [
                  const Icon(Icons.credit_card,
                      size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  if (_statisticsData != null && _statisticsData!.isNotEmpty)
                    CustomText(
                        placeholder:
                            '${_statisticsData![0]['data']['expenditure']}' +
                                ' XAF',
                        color: smartShopRed,
                        fontSize: 22,
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
                children: [
                  if (_statisticsData != null)
                    Icon(Icons.account_balance,
                        size: 64, color: Colors.purpleAccent.shade700
                        //rotate the ic
                        ),
                  const SizedBox(height: 16),
                  if (_statisticsData != null && _statisticsData!.isNotEmpty)
                    CustomText(
                        placeholder:
                            '${_statisticsData![0]['data']['total_profit']}' +
                                ' XAF',
                        color: smartShopYellow,
                        fontSize: 22,
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
                children: [
                  const Icon(Icons.all_inbox, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  if (_statisticsData != null && _statisticsData!.isNotEmpty)
                    CustomText(
                        placeholder:
                            '${_statisticsData![0]['data']['total_components']}',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: smartShopYellow)
                  else
                    const RefreshProgressIndicator(),
                  const SizedBox(height: 8),
                  const CustomText(placeholder: 'Total Items'),
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
        body: _statisticsData != null && _statisticsData!.isNotEmpty ?
        ListView(
          scrollDirection: Axis.vertical,
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      //put text vertically in the center

                      alignment: Alignment.center,
                      child: CustomText(
                        textAlign: TextAlign.center,
                        // vertical center
                        placeholder:
                            'Welcome to your dashboard $_loggedInUserNickname!\nHere, you can manage your stocks, easily view your statistics and manage your inventory.',
                        fontSize: 13,
                      )),
                ],
              ),
            ),
            const DataTableWidget(),
            const Padding(padding: EdgeInsets.all(32)),
          ],
        ) : const Center(
          child: RefreshProgressIndicator(),
        ),
      );
    } else {
      return PageScaffold(
        title: 'Dashboard',
        body:         _statisticsData != null && _statisticsData!.isNotEmpty ?
        ListView(
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
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(padding: EdgeInsets.all(32)),
                          MyForm(),
                          RestockForm(),
                          Padding(padding: EdgeInsets.all(32)),
                        ]),
                  ),
                ),
              ],
            ),
          ],
        ) : const Center(child: RefreshProgressIndicator()),
      );
    }
  }
}
