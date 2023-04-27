import 'package:flutter/material.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/dashboard/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/screens/modals/restock_form.dart';

class Stocks extends StatelessWidget {
  const Stocks({Key? key});

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
                  Icon(
                    Icons.arrow_upward,
                    size: 64,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  Text('Items in Stock'),
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
                  Icon(Icons.arrow_downward_sharp, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Out of Stock'),
                  SizedBox(height: 8),
                  Text('200'),
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
        title: 'Stocks',
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ...cards,
            const DataTableWidget(),
            const SizedBox(height: 24),
            const RestockForm(),
            const SizedBox(height: 24),
          ],
        ),
      );
    } else {
      return PageScaffold(
        title: 'Stocks Page',
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
