import 'package:flutter/material.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:ilocate/screens/auth/register.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/splash/splash.dart';

class CustomeRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => const Register());
      case '/dashobard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Splash());
    }
  }
}
