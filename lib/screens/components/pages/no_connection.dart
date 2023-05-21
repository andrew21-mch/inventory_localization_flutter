import 'package:SmartShop/custom_widgets/CustomText.dart';
import 'package:SmartShop/main.dart';
import 'package:SmartShop/providers/sharePreference.dart';
import 'package:SmartShop/responsive.dart';
import 'package:SmartShop/styles/colors.dart';
import 'package:flutter/gestures.dart';
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
    if (mounted) {
      setState(() {
        message = newMessage;
      });
    }
  }

  void _loadMessage() async {
    final message = await DatabaseProvider().getMessage();
    _setMessage(message);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: smartShopYellow,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Responsive.isMobile(context) ? 100 : 120),
             Center(
              child: Icon(
                Icons.wifi_off,
                size: 100,
                color: smartShopYellow,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  width: Responsive.isMobile(context) ? 200 : 400,
                  child: const Text(
                    'Could not connect to the server.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
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
            SizedBox(
              width: Responsive.isMobile(context) ? 200 : 400,
              child: const Center(
                child: CustomText(
                  placeholder:
                      '1. Check if you are connected to your local wifi and that the server is running',
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: Responsive.isMobile(context) ? 200 : 400,
              child: const Center(
                child: CustomText(
                  placeholder:
                      '2. Restart the Server, Connect to the wifi and refresh the app',
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: CustomText(placeholder:
                'If the problem persists, contact the developer',
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: smartShopYellow,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Powered by ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: ' SmartShop',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch('mailto:nfonandrew73@gmail.com');
                    },
                ),
              ),
            ],
          ),
        ),
        //  back button

        //  back button
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.restorablePopAndPushNamed(context, ' ');
        },
        backgroundColor: smartShopYellow,
        // refresh icon
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

launch(String s) {
//  launch email
}
