import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ControlPage extends StatefulWidget {
  final BluetoothConnection connection;

  ControlPage({super.key, required this.connection});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool _isListening = false;
  SpeechToText speechToText = SpeechToText();
  dynamic text = '';

  void _vibrate() async {
    // Check if the device supports vibration
    if (await Vibrate.canVibrate) {
      // Vibrate for 100 milliseconds
      Vibrate.feedback(FeedbackType.light);
      Vibrate.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lock the orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    return Scaffold(
      body: Stack(
        // alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF070F2B),
                      Color(0xFF1B1A55),
                      Color(0xFF535C91)
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          Padding(
            // padding: EdgeInsets.only(left: 250,top:50),
            padding: EdgeInsets.only(left: 35.0.h, top: 10.0.w),

            child: Text(
              "RoboRoamer Remote",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Aldrich',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // fontSize: 20
                fontSize: 17.0.sp,
              ),
            ),
          ),
          Padding(
            // padding: EdgeInsets.only(left: 15,top: 80),
            padding: EdgeInsets.only(left: 4.5.h, top: 20.0.w),

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                // borderRadius: BorderRadius.circular(15), // Rounded corners
                borderRadius: BorderRadius.circular(4.0.w),
                // Rounded corners

                // border: Border.all(color: Colors.white54, width: 3), // White border
                border: Border.all(
                    color: Colors.white54, width: 0.9.w), // White border
              ),
              // width: 700,
              width: 92.0.h,
              // height: 270,
              height: 75.0.w,
            ),
          ),
          Padding(
            // padding: EdgeInsets.only(top: 270, left: 180),
            padding: EdgeInsets.only(top: 73.0.w, left: 24.0.h),

            child: AvatarGlow(
              animate: _isListening,
              duration: Duration(milliseconds: 2000),
              glowColor: Colors.white,
              repeat: true,
              glowShape: BoxShape.circle,
              child: GestureDetector(
                onTapDown: (details) async {
                  _vibrate();
                  print('tapped');
                  if (!_isListening) {
                    bool available = await speechToText.initialize();
                    if (available) {
                      setState(() {
                        _isListening = true;
                        speechToText.listen(onResult: (result) {
                          text = result.recognizedWords;
                          print('The text is: ' + text);
                          if (text == 'forward') {
                            _sendCommand('F');
                            print('forward');
                          } else if (text == 'backward') {
                            _sendCommand('B');
                            print('backward');
                          } else if (text == 'left') {
                            _sendCommand('L');
                            print('left');
                          } else if (text == 'right') {
                            _sendCommand('R');
                            print('right');
                          } else if (text == 'stop') {
                            _sendCommand('S');
                          }

                          text = '';
                        });
                      });
                    }
                  }
                },
                onTapUp: (details) {
                  speechToText.stop();
                  setState(() {
                    _isListening = false;
                    text = '';
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  // radius: 30,
                  radius: 8.3.w,

                  // child: Icon(_isListening? Icons.mic: Icons.mic_none,color: Colors.black,size: 30,),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.black,
                    size: 8.5.w,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
              onTapDown: (details) {
                _vibrate();
                _sendCommand('S');
              },
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
                // padding: EdgeInsets.only(top: 260, left: 470),
                padding: EdgeInsets.only(top: 72.0.w, left: 62.0.h),

                child: Image.asset(
                  "assets/images/stop.png",
                  width: 20.0.w,
                  height: 19.0.w,
                ),
              )),
          Padding(
              // padding: EdgeInsets.only(top: 285, left: 488),
              padding: EdgeInsets.only(top: 79.0.w, left: 64.4.h),
              child: GestureDetector(
                onTapDown: (details) {
                  _vibrate();
                  _sendCommand('S');
                },
                onTapUp: (details) => _sendCommand('S'),
                child: Text(
                  'Stop',
                  style: TextStyle(
                    fontFamily: 'Aldrich',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          GestureDetector(
              onTapDown: (details) {
                _vibrate();
                _sendCommand('F');
              },
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
                // padding: EdgeInsets.only(top: 120, left: 50),
                padding: EdgeInsets.only(top: 33.3.w, left: 7.5.h),

                child: Image.asset(
                  "assets/images/Up_Buttoncontrol.png",
                ),
              )),
          GestureDetector(
              onTapDown: (details) {
                _vibrate();
                _sendCommand('B');
              },
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
                // padding: EdgeInsets.only(top: 230, left: 50),
                padding: EdgeInsets.only(top: 64.0.w, left: 7.5.h),

                child: Image.asset(
                  "assets/images/down_Buttoncontrol.png",
                ),
              )),
          Padding(
            // padding: EdgeInsets.only(left: 590,top: 170),
            padding: EdgeInsets.only(left: 85.3.h, top: 55.0.w),

            child: Transform.scale(
              scale: 2.0, // Adjust the scale factor as needed
              child: Image.asset(
                "assets/images/black_car_flip.png",
                height: 30.0.w, // Adjust the height if necessary
              ),
            ),
          ),
          GestureDetector(
              onTapDown: (details) {
                _vibrate();
                _sendCommand('L');
              },
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
                // padding: EdgeInsets.only(top: 160, left: 530),
                padding: EdgeInsets.only(top: 44.0.w, left: 71.0.h),

                child: Image.asset(
                  "assets/images/left_Buttoncontrol.png",
                ),
              )),
          GestureDetector(
              onTapDown: (details) {
                _vibrate();
                _sendCommand('R');
              },
              onTapUp: (details) => _sendCommand('S'),
              child: Padding(
                // padding: EdgeInsets.only(top: 160, left: 630),
                padding: EdgeInsets.only(top: 44.0.w, left: 85.0.h),

                child: Image.asset(
                  "assets/images/right_Buttoncontrol.png",
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 35.0.w, left: 38.0.h),
              child: Text(
                "Distance between obstacle",
                style: TextStyle(
                    fontFamily: 'Aldrich',
                    fontSize: 13.0.sp,
                    color: Colors.white),
              )),
        ],
      ),
    );
  }

  void _sendCommand(String command) async {
    List<int> list = command.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection.output.add(bytes);
    print(command.toString());
    await widget.connection.output.allSent;
    // You can add any additional logic or UI updates based on the command if needed
  }
}
