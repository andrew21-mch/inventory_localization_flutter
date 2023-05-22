import 'package:SmartShop/screens/modals/AddSale.dart';
import 'package:SmartShop/screens/modals/install_led.dart';
import 'package:SmartShop/styles/colors.dart';
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
        title: CustomText(placeholder: title, color: smartShopWhite),
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
              const PopupMenuItem(
                value: 'Install Led',
                child: Text('Install Led'),
              ),
              const PopupMenuItem(
                value: 'Sell Item',
                child: Text('Sell Item'),
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
              } else if (value == 'Install Led') {
                //  bottom sheet that shows a form to add a new location
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const LedForm(),
                );
              }else if (value == 'Sell Item') {
                //  bottom sheet that shows a form to add a new location
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddSalesForm(),
                );
              }
            },
          ),

          // notification icon with a badge and a number
          Row(
            children: [
              //animated icon
              PopupMenuButton(
                //style it to look like notification
                padding: const EdgeInsets.all(8),
                shadowColor: smartShopBlue,
                elevation: 10,
                icon: const Icon(Icons.notifications),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                   PopupMenuItem(
                    textStyle: TextStyle(color: smartShopGreen, fontSize: 12),
                    child: CustomText(
                      placeholder: 'First Notification',
                      color: smartShopGreen,
                      fontSize: 12,
                    ),
                  ),
                   PopupMenuItem(
                    child: CustomText(
                      placeholder: 'Second Notification',
                      color: smartShopGreen,
                      fontSize: 12,
                    ),
                  ),
                   PopupMenuItem(
                     child: CustomText(
                       placeholder: 'Third Notification',
                       color: smartShopGreen,
                       fontSize: 12,
                     ),
                  ),
                  PopupMenuItem(
                    child: CustomText(
                      placeholder: 'Fourth Notification',
                      color: smartShopGreen,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              CircleAvatar(
                radius: 10,
                backgroundColor: smartShopWhite,
                child: CustomText(
                  placeholder: '2',
                  color: smartShopRed,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          ...actions,
        ],
        backgroundColor: smartShopYellow,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
