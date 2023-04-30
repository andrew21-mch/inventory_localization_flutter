import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilocate/screens/dashboard/split_view.dart';
import '../../routes/routes.dart';
import '../components/pages/appmenu.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return MaterialApp(
      onGenerateRoute: CustomeRoute.allRoutes,
      color: Colors.white,
      home: SplitView(
        menu: const AppMenu(),
        content: selectedPageBuilder(context),
      ),
    );
  }
}
