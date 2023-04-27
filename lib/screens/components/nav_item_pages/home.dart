import 'package:flutter/material.dart';
import 'package:ilocate/screens/modals/add_item_form.dart';
import 'package:ilocate/screens/components/search_bar.dart';
import 'package:ilocate/screens/dashboard/items_table.dart';
import 'package:ilocate/screens/dashboard/pagescafold.dart';
import 'package:ilocate/screens/modals/restock_form.dart';
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
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // padding: const EdgeInsets.all(32.0),
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 32, 16, 0),
                    child:  Text('Welcome to your dashboard $name!',
                        style: TextStyle(
                            color: ilocateYellow,
                            textBaseline: TextBaseline.alphabetic)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 64, 32, 32),
                    child: const MyForm(),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 16, 32, 32),
                    child: const RestockForm(),
                  )
                ],
              ),
            ),
                   const SearchBar(),
                   const DataTableWidget(),
            const Padding(padding: EdgeInsets.all(32)),

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
            const DataTableWidget(),
            const Padding(padding: EdgeInsets.all(32)),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    MyForm(),
                    RestockForm(),
                  ]),
            ),
            const Padding(padding: EdgeInsets.all(32)),
          ],
        ),
      );
    }
  }

//   Future openDialogue(BuildContext context, isMobile) => showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           scrollable: true,
//           title: Row(
//             children: [
//               Text('Add Component',
//                   style: TextStyle(
//                       color: ilocateYellow,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold)),
//               const SizedBox(width: 10),
//               const Icon(Icons.add_circle_outline)
//             ],
//           ),
//           backgroundColor: ilocateLight,
//           content: SingleChildScrollView(
//             child: SizedBox(
//               width: isMobile ? null : 600,
//               child: Column(
//                 children: [
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Item Name',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Description',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Bought At',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Selling At',
//                     ),
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Quantity',
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     // set a width
//                     isExpanded: true,
//                     value: 'Supplier A',
//                     icon: const Icon(Icons.arrow_downward),
//                     iconSize: 24,
//                     elevation: 16,
//                     style: const TextStyle(color: Colors.deepPurple),
//                     underline: Container(
//                       height: 2,
//                       color: Colors.deepPurpleAccent,
//                     ),
//                     onChanged: (String? newValue) {},
//                     items: <String>[
//                       'Supplier A',
//                       'Supplier B',
//                       'Supplier C',
//                       'Supplier D'
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   //   select supplier
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(ilocateYellow),
//               ),
//               child:
//                   const Text('Cancel', style: TextStyle(color: Colors.white)),
//             ),
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(ilocateYellow),
//                 ),
//                 child:
//                     const Text('Add', style: TextStyle(color: Colors.white))),
//           ],
//         ),
//       );
}
