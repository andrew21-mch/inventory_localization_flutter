import 'package:flutter/material.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/dashboard/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/styles/colors.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({super.key});

  @override
  Widget build(BuildContext context) {
    const name = 'John Doe';
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
                children: const [
                  Icon(Icons.money_off_csred, size: 64),
                  SizedBox(height: 16),
                  Text('XAF 400, 000'),
                  SizedBox(height: 8),
                  Text('Total Expenses'),
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
                children: const [
                  Icon(Icons.money, size: 64),
                  SizedBox(height: 16),
                  Text('XAF 400, 000'),
                  SizedBox(height: 8),
                  Text('Total Income'),
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
                children: const [
                  Icon(Icons.attach_money, size: 64),
                  SizedBox(height: 16),
                  Text('127'),
                  SizedBox(height: 8),
                  Text('Total Items'),
                ],
              ),
            ),
          ),
        ),
      ),
      // fourth card
    ];

    final cards2 = [
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
                children: const [
                  Icon(Icons.pie_chart, size: 64),
                  SizedBox(height: 16),
                  Text('50%'),
                  SizedBox(height: 8),
                  Text('Sales and Purchases'),
                ],
              ),
            ),
          ),
        ),
      ),
      // fifth card
      Expanded(
        flex: 1,
        child: Card(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.show_chart, size: 64),
                  SizedBox(height: 16),
                  Text('15%'),
                  SizedBox(height: 8),
                  Text('Revenue Growth'),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
    if (isMobile) {
      return PageScaffold(
        title: 'Dashboard',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // welcome card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text('Welcome to your dashboard $name!',
                    // colors
                    style: TextStyle(color: ilocateAmber)),
              ),
            ),
            const SearchBar(), const DataTableWidget()
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
                ...cards,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...cards2,
              ],
            ),
            const SearchBar(),
            const DataTableWidget()
          ],
        ),
      );
    }
  }
}
