import 'package:flutter/material.dart';
import 'package:ilocate/routes/routes.dart';
import 'package:ilocate/screens/auth/route_names.dart';
import 'package:ilocate/screens/customs/button.dart';
import 'package:ilocate/styles/colors.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Ilocate',
        onGenerateRoute: CustomeRoute.allRoutes,
        home: Scaffold(
            body: ListView(

                children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(72.0),
                  child: Center(
                    child: Image.asset('assets/images/logo.png',
                        width: 200,
                        height: 200,
                        color: ilocateYellow,
                        fit: BoxFit.cover),
                  )),
              Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Builder(
                    builder: (context) => Center(
                      child: CustomButton(
                          placeholder: 'Get Started',
                          color: ilocateYellow,
                          method: () {
                            Navigator.pushNamed(context, register);
                          }),
                    ),
                  )),
            ],
          )
        ])));
  }
}
