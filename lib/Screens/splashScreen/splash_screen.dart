import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: Text("Loading...",
        style: Theme.of(context).textTheme.subtitle2
        // TextStyle(
        //   color: Colors.black,
        //   fontWeight: FontWeight.bold
        // ),
        ),
      ),
    );
  }
}
