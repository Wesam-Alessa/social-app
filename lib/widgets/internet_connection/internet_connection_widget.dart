import 'package:flutter/material.dart';

class InternetConnection extends StatelessWidget {
  const InternetConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Column(
          children: [
            Text(
              'Internet connection failed',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 5.0,
            ),
            LinearProgressIndicator(
              minHeight: 5,
            )
          ],
        ),
      ),
    );
  }
}
