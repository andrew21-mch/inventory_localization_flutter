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
// final ledProvider = ChangeNotifierProvider((ref) => LedProvider());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  bool isAuth = false;

  //method to check if user is logged in
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
      child: GetMaterialApp
  (
        debugShowCheckedModeBanner: false,
        onGenerateRoute: CustomRoute.allRoutes,
        title: 'Ilocate',
        home: isAuth ? const DashboardScreen() : const Splash(),
      ),
    );
  }
}
