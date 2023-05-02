import 'package:flutter/material.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/providers/sharePreference.dart';
import 'package:ilocate/screens/components/leds/led_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/screens/modals/install_led.dart';
import 'package:ilocate/styles/colors.dart';
import 'package:ilocate/utils/snackMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leds extends StatefulWidget {
  const Leds({Key? key}) : super(key: key);


  @override
  _LedsState createState() => _LedsState();
}

class _LedsState extends State<Leds> {
  String? message;
  late int ledTotal;

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
      this.ledTotal = ledTotal;
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
        : (MediaQuery.of(context).size.width - 80) / 3;

    final cards = [
      // first card
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
                  //  icon for money coin
                  const Icon(Icons.lightbulb, size: 64, color: Colors.yellow),
                  const SizedBox(height: 16),
                  const Text('LEDs Installed'),
                  const SizedBox(height: 8),
                  Text(
                    '$ledTotal',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // second card
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
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [LedForm()]),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'LEDs Page',
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
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [LedForm()]),
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
