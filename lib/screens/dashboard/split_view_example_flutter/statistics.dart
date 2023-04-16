import 'package:flutter/material.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/dashboard/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key});

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
                  Icon(Icons.people, size: 64),
                  SizedBox(height: 16),
                  Text('Users'),
                  SizedBox(height: 8),
                  Text('1000'),
                ],
              ),
            ),
          ),
        ),
      ),
      // second card
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
                  Icon(Icons.bar_chart, size: 64),
                  SizedBox(height: 16),
                  Text('Sales'),
                  SizedBox(height: 8),
                  Text('\$10,000'),
                ],
              ),
            ),
          ),
        ),
      ),
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
                children: const [
                  Icon(Icons.attach_money, size: 64),
                  SizedBox(height: 16),
                  Text('Profit'),
                  SizedBox(height: 8),
                  Text('\$5,000'),
                ],
              ),
            ),
          ),
        ),
      )
    ];

    if (isMobile) {
      return PageScaffold(
        title: 'Dashboard',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const DataTableWidget(),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Statistics Page',
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
              const DataTableWidget(),
            ],
          ),
        ),
      );
    }
  }
}
