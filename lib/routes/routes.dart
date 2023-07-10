import 'package:SmartShop/main.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/screens/auth/login.dart';
import 'package:SmartShop/screens/auth/register.dart';
import 'package:SmartShop/screens/auth/reset_password.dart';
import 'package:SmartShop/screens/components/pages/ItemDetails.dart';
import 'package:SmartShop/screens/dashboard/dashboard.dart';
import 'package:SmartShop/splash/splash.dart';

class CustomRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyApp());
      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => const Register());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/reset_password':
        return MaterialPageRoute(builder: (_) => const PasswordReset());
      case '/item_details':
        return MaterialPageRoute(builder: (_) => const ItemDetail());
      default:
        return MaterialPageRoute(builder: (_) => const Login());
    }
  }
}
