import 'package:flutter/material.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/screens/modals/add_item_form.dart';
import 'package:SmartShop/screens/modals/restock_form.dart';
import 'package:SmartShop/styles/colors.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    Key? key,
    required this.title,
    this.actions = const [],
    this.body,
    this.floatingActionButton,
  }) : super(key: key);
  final String title;
  final List<Widget> actions;
  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    // 1. look for an ancestor Scaffold
    final ancestorScaffold = Scaffold.maybeOf(context);
    // 2. check if it has a drawer
    final hasDrawer = ancestorScaffold != null && ancestorScaffold.hasDrawer;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // 3. add a non-null leading argument if we have a drawer
        leading: hasDrawer
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed:
                    hasDrawer ? () => ancestorScaffold.openDrawer() : null,
              )
            : null,
        title: CustomText(placeholder: title, color: ilocateWhite),
        actions: [

          // an icon that when click it shows a popup menu with the options to add a new user or a new location
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'Add User',
                child: Text('Add Item'),
              ),
              const PopupMenuItem(
                value: 'Restock Item',
                child: Text('Restock Item'),
              ),
            ],
            onSelected: (value) {
              if (value == 'Add User') {
              //  bottom sheet that shows a form to add a new user
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const MyForm(),
                );
              } else if (value == 'Restock Item') {
                //  bottom sheet that shows a form to add a new location
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const RestockForm(),
                );
              }
            },
          ),
          ...actions,
        ],
        backgroundColor: ilocateYellow,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
