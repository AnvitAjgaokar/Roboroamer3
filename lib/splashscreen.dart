import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                // colors: [Color(0xFF070F2B), Color(0xFF1B1A55),Color(0xFF535C91)],
                colors: [Color(0xFF535C91), Color(0xFF1B1A55),Color(0xFF070F2B)],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [0.0, 0.5,1.0],
                tileMode: TileMode.clamp)),
        child: Column(
          children: [
            Text("Robo-Roamer",style: TextStyle(fontFamily: 'Aldrich',fontWeight: FontWeight.bold),),
            
          ],
        ),
      ),
    );
  }
}
