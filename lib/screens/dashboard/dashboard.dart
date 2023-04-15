import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilocate/screens/dashboard/split_view.dart';
import 'package:ilocate/screens/dashboard/split_view_example_flutter/appmenu.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // 2. add a WidgetRef argument
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. watch selectedPageBuilderProvider
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return MaterialApp(
      color: Colors.white,
      home: SplitView(
        menu: const AppMenu(),
        content: selectedPageBuilder(context),
      ),
    );
  }
}
