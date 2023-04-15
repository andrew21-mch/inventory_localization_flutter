import 'package:flutter/material.dart';
import 'package:ilocate/styles/colors.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ilocate',
      home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Image.asset('assets/images/logo.png',
                        width: 200,
                        height: 200,
                        color: ilocateYellow,
                        fit: BoxFit.cover),
                  )),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('You clicked me');
              },
              backgroundColor: Colors.grey,
              child: const Text('Go..'))),
      color: Colors.orange,
    );
  }
}
