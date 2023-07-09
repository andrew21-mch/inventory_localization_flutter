import 'package:SmartShop/screens/components/pages/profile.dart';
import 'package:SmartShop/screens/components/pages/suppliers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/screens/components/clippath.dart';
import 'package:SmartShop/screens/components/pages/sales.dart';
import 'package:SmartShop/screens/components/pages/statistics.dart';
import 'package:SmartShop/screens/components/pages/stock.dart';
import 'package:SmartShop/screens/dashboard/page_list_tile.dart';
import 'package:SmartShop/screens/modals/logout.dart';
import 'package:SmartShop/styles/colors.dart';

import 'home.dart';
import 'led_page_view.dart';

final _availablePages = <String, WidgetBuilder>{
  'Home, home': (_) => const AuthHome(),
  'Stocks, stocks': (_) => const Stocks(),
  'Sales, sales': (_) => const Sales(),
  'Statistics, statistics': (_) => const Statistics(),
  'LEDs, lightbulb': (_) => const Leds(),
  'Suppliers, user': (_) => const Suppliers(),
  'Profile, user': (_) => const Profile(),
};

final selectedPageNameProvider = StateProvider<String>((ref) {
  // default value
  return _availablePages.keys.first;
});

final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return _availablePages[selectedPageKey]!;
});

class AppMenu extends ConsumerWidget {
  const AppMenu({super.key});

  // 2. Add a WidgetRef argument
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. watch the provider's state
    final isMobile = MediaQuery.of(context).size.width < 600;

    final selectedPageName = ref.watch(selectedPageNameProvider.state).state;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(placeholder: 'Menu', color: smartShopWhite),
        backgroundColor: smartShopYellow,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                const ClipPathWidget(),
                for (var pageName in _availablePages.entries)
                  PageListTile(
                    icon: pageName.key.contains('home')
                        ?  Icon(Icons.home, color: smartShopBlue)
                        : pageName.key.contains('stocks')
                            ? Icon(Icons.inventory, color: smartShopBlue)
                            : pageName.key.contains('sales')
                                ? Icon(Icons.shopping_cart, color: smartShopGreen)
                                : pageName.key.contains('statistics')
                                    ? Icon(Icons.bar_chart, color: smartShopGreen)
                                    : pageName.key.contains('lightbulb')
                                        ?  const Icon(Icons.lightbulb, color: Colors.yellowAccent)
                                        : pageName.key.contains('user')
                                            ? const Icon(Icons.person, color: Colors.blue)
                                        : null,

                    selectedPageName: selectedPageName,
                    pageName: pageName.key.split(',').first,
                    onPressed: () => _selectPage(context, ref, pageName.key),
                  ),
              ],

            ),
          ),
          PageListTile(
            selectedPageName: selectedPageName,
            pageName: 'Logout',
            icon: const Icon(Icons.logout),
            iconTransform: Matrix4.rotationZ(
              3.143,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const LogoutModal();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    // only change the state if we have selected a different page
    if (ref.read(selectedPageNameProvider.state).state != pageName) {
      ref.read(selectedPageNameProvider.state).state = pageName;
      // dismiss the drawer of the ancestor Scaffold if we have one
      if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
        isMobile
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _availablePages[pageName]!(context)))
            : Get.to(() => _availablePages[pageName]!,
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 500));
        if (isMobile) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => _availablePages[pageName]!(context)),
          );
        } else {
          Get.to(
            () => _availablePages[pageName]!(context),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    }
  }
}
