import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilocate/screens/components/clippath.dart';
import 'package:ilocate/screens/dashboard/page_list_tile.dart';
import 'package:ilocate/screens/dashboard/split_view_example_flutter/home.dart';
import 'package:ilocate/screens/dashboard/split_view_example_flutter/statistics.dart';
import 'package:ilocate/screens/dashboard/split_view_example_flutter/stock.dart';
import 'package:ilocate/styles/colors.dart';

final _availablePages = <String, WidgetBuilder>{
  'Home': (_) => const AuthHome(),
  'Stocks': (_) => const Stocks(),
  'Statistics': (_) => const Statistics(),
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
    final selectedPageName = ref.watch(selectedPageNameProvider.state).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: ilocateYellow,
        // add profile icon to the to right
      ),
      body: ListView(
        children: <Widget>[
          const ClipPathWidget(),
          for (var pageName in _availablePages.keys)
            PageListTile(
              selectedPageName: selectedPageName,
              pageName: pageName,
              onPressed: () => _selectPage(context, ref, pageName),
            )
        ],
      ),
    );
  }

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    // only change the state if we have selected a different page
    if (ref.read(selectedPageNameProvider.state).state != pageName) {
      ref.read(selectedPageNameProvider.state).state = pageName;
      // dismiss the drawer of the ancestor Scaffold if we have one
      if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
        Navigator.of(context).pop();
      }
    }
  }
}
