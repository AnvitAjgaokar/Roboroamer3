import 'package:flutter/material.dart';
import 'package:roboroamer1/blue_list.dart';
import 'package:roboroamer1/splashscreen.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: SplashScreen(),
      );
    });
  }
}
