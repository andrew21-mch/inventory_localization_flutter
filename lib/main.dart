import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ilocate/providers/authProvider.dart';
import 'package:ilocate/providers/ledProvider.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/splash/splash.dart';

import 'models/User.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: MyApp(),
      ),
    ),

  );

  Get.config(
    defaultTransition: Transition.fade,
    defaultOpaqueRoute: false,
    defaultPopGesture: true,
  );

}

final authProvider = ChangeNotifierProvider((ref) => AuthProvider());
final userProvider = ChangeNotifierProvider((ref) => UserModel());
final ledProvider = ChangeNotifierProvider((ref) => LedProvider());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        ledProvider.overrideWithProvider(
          ChangeNotifierProvider((ref) => LedProvider()),
        ),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ilocate',
        home: DashboardScreen(),
      ),
    );
  }
}
