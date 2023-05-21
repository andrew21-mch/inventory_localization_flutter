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
  'Home': (_) => const AuthHome(),
  'Stocks': (_) => const Stocks(),
  'Sales': (_) => const Sales(),
  'Statistics': (_) => const Statistics(),
  'LEDs': (_) => const Leds(),
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
                for (var pageName in _availablePages.keys)
                  PageListTile(
                    selectedPageName: selectedPageName,
                    pageName: pageName,
                    onPressed: () => _selectPage(context, ref, pageName),
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
