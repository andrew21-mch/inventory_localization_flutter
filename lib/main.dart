import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ilocate/providers/authProvider.dart';
import 'package:ilocate/splash/splash.dart';

import 'models/User.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final authProvider = ChangeNotifierProvider((ref) => AuthProvider());
final userProvider = ChangeNotifierProvider((ref) => UserModel());

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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ilocate',
        home: Splash(),
      ),
    );
  }
}
