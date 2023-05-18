import 'package:SmartShop/responsive.dart';
import 'package:flutter/material.dart';
import 'package:SmartShop/routes/routes.dart';
import 'package:SmartShop/screens/auth/route_names.dart';
import 'package:SmartShop/screens/customs/button.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:http/http.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Ilocate',
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
        ])));
  }
}
