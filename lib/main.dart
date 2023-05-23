import 'package:SmartShop/providers/ledProvider.dart';
import 'package:SmartShop/providers/outOfStockProvider.dart';
import 'package:SmartShop/providers/salesProvider.dart';
import 'package:SmartShop/screens/components/pages/no_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:SmartShop/providers/authProvider.dart';
import 'package:SmartShop/routes/routes.dart';
import 'package:SmartShop/screens/dashboard/dashboard.dart';
import 'package:SmartShop/splash/splash.dart';

import 'models/User.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

final authProvider = ChangeNotifierProvider((ref) => AuthProvider());
final userProvider = ChangeNotifierProvider((ref) => UserModel());
final ledProvider = ChangeNotifierProvider((ref) => LedProvider());
final salesProvider = ChangeNotifierProvider((ref) => SalesProvider());
final stocksProvider = ChangeNotifierProvider((ref) => OutOfStockProvider());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuth = false;
  bool canConnect = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
    checkAuth();
  }

  // method to check if the user is logged in
  void checkAuth() async {
    final auth = AuthProvider().isAuthenticated();
    if (await auth) {
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  void checkConnection() async {
    final connection = AuthProvider().checkConnection();
    if (await connection) {
      if(mounted){
        setState(() {
          canConnect = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          canConnect = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWithProvider(
          ChangeNotifierProvider((ref) => AuthProvider()),
        ),
        userProvider.overrideWithProvider(
          ChangeNotifierProvider((ref) => UserModel()),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: CustomRoute.allRoutes,
        title: 'smartShop',
        home: canConnect && isAuth
            ? const DashboardScreen()
            : canConnect && !isAuth
                ? const Splash()
            : const NoConnectionScreen(),
      ),
    );
  }
}
