import 'package:SmartShop/providers/authProvider.dart';
import 'package:SmartShop/responsive.dart';
import 'package:SmartShop/screens/components/pages/no_connection.dart';
import 'package:SmartShop/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/routes/routes.dart';
import 'package:SmartShop/screens/auth/route_names.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/styles/colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool canConnect = false;
  bool isAuth = false;

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

    // check connection


    return canConnect ?
      MaterialApp(
        title: 'smartShop',
        onGenerateRoute: CustomRoute.allRoutes,
        home: Scaffold(
            body: ListView(

                children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: Responsive.isTablet(context)
                      ? const EdgeInsets.only(top: 100)
                      : Responsive.isMobile(context)
                          ? const EdgeInsets.only(top: 50)
                          : const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Image.asset('assets/images/cover.png',
                        color: ilocateYellow,
                        fit: BoxFit.contain,
                        width: Responsive.isTablet(context) ? 400 : Responsive.isMobile(context) ? 300 : 500,
                        height: Responsive.isTablet(context) ? 400 : Responsive.isMobile(context) ? 300 : 500
                    ),
                  )),
              Builder(
                builder: (context) => Center(
                  child: CustomButton(
                      width: 400,
                      icon: Icons.double_arrow,
                      placeholder: 'Get Started',
                      color: ilocateYellow,
                      method: () {
                        Navigator.pushNamed(context, register);
                      }),
                ),
              ),
            ],
          )
        ]))) : isAuth ? const DashboardScreen() : const NoConnectionScreen();
  }
}
