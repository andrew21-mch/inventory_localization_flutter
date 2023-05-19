import 'package:SmartShop/main.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  _NoConnectionScreenState createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {

  String? message;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  void _setMessage(String newMessage) {
    if(mounted) {
      setState(() {
        message = newMessage;
      });
    }
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(message, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          duration: const Duration(seconds: 2),
        ),
      );
    });

    // clear message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Center(
              child: Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.red,
              ),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(width: 10),
            Flexible(
              child: Text(
               'Could not connect to the server.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Please try the following:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          '1. Check if you are connected to the internet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          '2. Check if the server is running',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          '3. Check if the server is running on port 8081',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      //  back button
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.restorablePopAndPushNamed(context, ' ');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
