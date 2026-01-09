import 'dart:async';

import 'package:chat/screens/loginscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget
{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 3),()
    {
       Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Loginscreen()));
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height:100,
              child: Image.asset("assets/images/logochatlink.png"))
          ],
        )
      )
    );
  }
}