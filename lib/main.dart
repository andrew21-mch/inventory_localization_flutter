import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilocate/screens/dashboard/dashboard.dart';
import 'package:ilocate/screens/auth/login.dart';
import 'package:ilocate/screens/auth/register.dart';
import 'package:ilocate/splash/splash.dart';

void main() {
  runApp(const ProviderScope(child: DashboardScreen()));
}
