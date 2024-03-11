import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roboroamer1/blue_list.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);

    // Delay navigation after 2 seconds
    Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BluetoothApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF535C91),
                      Color(0xFF1B1A55),
                      Color(0xFF070F2B)
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 9.0.w, top: 13.0.h),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: child,
                );
              },
              child: Text(
                "ROBO ROAMER",
                style: TextStyle(
                    fontFamily: 'Aldrich',
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32.0.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0.w, top: 45.0.h),
            child: Transform.scale(
                scale: 1.3,
                child: Image.asset("assets/images/white_car_newhalf.png")),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
