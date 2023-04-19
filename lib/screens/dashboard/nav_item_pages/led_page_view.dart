import 'package:flutter/material.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/dashboard/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/screens/install_led.dart';

import '../led_table.dart';

class Leds extends StatelessWidget {
  const Leds({super.key});

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
                children: const [
                  //  icon for money coin
                  Icon(Icons.lightbulb, size: 64, color: Colors.yellow),
                  SizedBox(height: 16),
                  Text('LEDs Installed'),
                  SizedBox(height: 8),
                  Text('20'),
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
            const SearchBar(),
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
              Row(
                children: const [
                  Expanded(
                    child: SearchBar(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [LedForm()]),
              ),
              const SizedBox(height: 16),
              const LedTableWidget(),
            ],
          ),
        ),
      );
    }
  }
}
