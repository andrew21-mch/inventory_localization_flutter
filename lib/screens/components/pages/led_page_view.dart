import 'package:SmartShop/custom_widgets/led_table.dart';
import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/screens/modals/install_led.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/screens/dashboard/pagescafold.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leds extends StatefulWidget {
  const Leds({Key? key}) : super(key: key);


  @override
  _LedsState createState() => _LedsState();
}

class _LedsState extends State<Leds> {
  String? message;
  String? _totalLeds;

  @override
  void initState() {
    super.initState();
    _loadMessage();
    _loadLedTotal();
  }

  void _setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  void _loadLedTotal() async {
    final ledTotal = await LedProvider().getLedTotal();
    setState(() {
      _totalLeds = ledTotal;
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width / 2) - 32;

    final cards = [
      // first card
     Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisSize: MainAxisSize.
                children: [
                  //  icon for money coin
                  const Icon(Icons.lightbulb, size: 64, color: Colors.yellow),
                  const SizedBox(height: 16),
                  const CustomText(placeholder: 'LEDs Installed'),
                  const SizedBox(height: 8),
                  CustomText(placeholder:
                    _totalLeds.toString(),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      // suggest another card here

      Card(
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(Icons.smart_button, size: 64, color: Colors.green),

                const SizedBox(height: 16),
                const CustomText(placeholder: 'Leds Connected'),
                const SizedBox(height: 8),
                CustomText(placeholder:
                  _totalLeds.toString(),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    if (isMobile) {
      return PageScaffold(
        title: 'LEDs Page',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            // const SearchBar(),
            const LedTableWidget(),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [LedForm()]),
            ),
            const SizedBox(height: 16),
          ],
        ),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'LEDs Page',
        body: SizedBox(
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.vertical,
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
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [LedForm()]),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              const LedTableWidget(),
              const Padding(padding: EdgeInsets.all(32)),
            ],
          ),
        ),
      );
    }
  }
}
