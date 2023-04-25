import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ilocate/providers/authProvider.dart';
import 'package:ilocate/splash/splash.dart';
import 'package:provider/provider.dart';

import 'models/User.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ilocate',
        home: Splash(),
      ),
    );
  }
}
