import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:SmartShop/screens/dashboard/split_view.dart';
import '../../routes/routes.dart';
import '../components/pages/appmenu.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return MaterialApp(
      onGenerateRoute: CustomRoute.allRoutes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
      color: Colors.white,
      home: SplitView(
        menu: const AppMenu(),
        content: selectedPageBuilder(context),
      ),
    );

  }
}
