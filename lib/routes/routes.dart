import 'package:flutter/material.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:ilocate/screens/auth/register.dart';
import 'package:ilocate/screens/auth/reset_password.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/splash/splash.dart';

class CustomeRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => const Register());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/reset_password':
        return MaterialPageRoute(builder: (_) => const PasswordReset());
      default:
        return MaterialPageRoute(builder: (_) => const Splash());
    }
  }
}
