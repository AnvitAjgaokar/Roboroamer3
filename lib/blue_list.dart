import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:roboroamer1/control_page.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  int? _deviceState;
  bool isDisconnecting = false;

  // Track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection!.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  // Define a bool to track permission status
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // Request Nearby Share permission in initState
    _requestNearbySharePermission().then((granted) {
      setState(() {
        _permissionGranted = granted;
        enableBluetooth();
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }

        enableBluetooth();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  Future<bool> _requestNearbySharePermission() async {
    var permissionStatus = await Permission.bluetoothScan.status;
    var permissionStatus2 = await Permission.bluetoothConnect.status;
    var permissionStatus3 = await Permission.bluetooth.status;

    if (permissionStatus.isGranted &&
        permissionStatus2.isGranted &&
        permissionStatus3.isGranted) {
      return true;
    } else {
      // Request permission if not granted
      var status = await Permission.bluetoothScan.request();
      var status2 = await Permission.bluetoothConnect.request();
      var status3 = await Permission.bluetooth.request();

      return status.isGranted && status2.isGranted && status3.isGranted;
    }
  }

  // Request Bluetooth permission from the user
  Future<bool> enableBluetooth() async {
// Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

// If the bluetooth is off, then turn it on first
// and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
      print("Retrieved devices: $devices"); // Check if devices are found here
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

// Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.center,
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                // borderRadius: BorderRadius.circular(15), // Rounded corners
                borderRadius: BorderRadius.circular(4.0.w), // Rounded corners

                border: Border.all(
                    color: Colors.white54, width: 0.9.w), // White border
              ),
              // width: 330,
              width: 91.7.w,
              // height: 650,
              height: 86.0.h,

              child: Padding(
                // padding: EdgeInsets.only(left: 5,right: 5),
                padding: EdgeInsets.only(left: 1.4.w, right: 1.4.w),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 20,),
                    SizedBox(
                      height: 2.6.h,
                    ),

                    Text(
                      "Paired Devices",
                      style: TextStyle(
                          // fontSize: 30,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Aldrich'),
                    ),
                    // const SizedBox(height: 5), // Adjust spacing between text and list
                    Expanded(
                      child: _permissionGranted && _devicesList.isNotEmpty
                          ? ListView.builder(
                              itemCount: _devicesList.length,
                              itemBuilder: (context, index) {
                                BluetoothDevice device = _devicesList[index];

                                return Padding(
                                  // padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.4.w),

                                  child: Card(
                                    // elevation: 20,
                                    elevation: 2.6.h,
                                    shadowColor: Colors.black,
                                    // Adjust elevation as needed
                                    shape: RoundedRectangleBorder(
                                      // borderRadius: BorderRadius.circular(40), // Rounded corners
                                      borderRadius: BorderRadius.circular(
                                          12.0.w), // Rounded corners
                                    ),
                                    color: Colors.white,
                                    // Tile color
                                    child: ListTile(
                                      title: Text(
                                        device.name.toString(),
                                        // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Aldrich'),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.7.sp,
                                            fontFamily: 'Aldrich'),
                                      ),
                                      subtitle: Text(
                                        device.address,
                                        // style: TextStyle(color: Colors.black,fontFamily: 'Aldrich'),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Aldrich',
                                            fontSize: 12.0.sp),
                                      ),
                                      onTap: () => _isButtonUnavailable
                                          ? null
                                          : _showConnectDialog(device),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                'No Bluetooth devices found.',
                                style: TextStyle(
                                    fontFamily: 'Aldrich',
                                    color: Colors.white,
                                    fontSize:
                                        14.0.sp), // Adjust message if needed
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              // padding: EdgeInsets.only(top:490, right: 173),
              padding: EdgeInsets.only(top: 64.0.h, right: 45.0.w),
              child: Transform.scale(
                scale: 1.5, // Adjust the scale factor as needed
                child: Image.asset(
                  "assets/images/black_car.png",
                  height: 25.0.h, // Adjust the height if necessary
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isButtonUnavailable = true;
    });

    if (!isConnected) {
      await BluetoothConnection.toAddress(device.address).then((_connection) {
        print('Connected to ${device.name}');
        connection = _connection;
        setState(() {
          _connected = true;
        });

        connection?.input?.listen(null).onDone(() {
          if (isDisconnecting) {
            print('Disconnecting locally!');
          } else {
            print('Disconnected remotely!');
          }
          if (this.mounted) {
            setState(() {});
          }
        });

        // Navigate to the control page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControlPage(connection: connection!),
          ),
        );
      }).catchError((error) {
        print('Cannot connect, exception occurred');
        print(error);
      });

      show('Connected to ${device.name}');

      setState(() => _isButtonUnavailable = false);
    }
  }

// Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection?.input?.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

// void _onDataReceived(Uint8List data) {
//   // Allocate buffer for parsed data
//   int backspacesCounter = 0;
//   data.forEach((byte) {
//     if (byte == 8 || byte == 127) {
//       backspacesCounter++;
//     }
//   });
//   Uint8List buffer = Uint8List(data.length - backspacesCounter);
//   int bufferIndex = buffer.length;
//
//   // Apply backspace control character
//   backspacesCounter = 0;
//   for (int i = data.length - 1; i >= 0; i--) {
//     if (data[i] == 8 || data[i] == 127) {
//       backspacesCounter++;
//     } else {
//       if (backspacesCounter > 0) {
//         backspacesCounter--;
//       } else {
//         buffer[--bufferIndex] = data[i];
//       }
//     }
//   }
// }

// Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection?.close();
    show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

// Method to send message,
// for turning the Bluetooth device off

// Method to show a Snackbar,
// taking message as the text
  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));

    SnackBar(
      content: new Text(
        message,
      ),
      duration: duration,
    );
  }

  void _showConnectDialog(BluetoothDevice device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Transparent background color
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SizedBox(
            width: 5.0.w, // Adjust the width to make it smaller
            height: 30.0.w, // Adjust the height to make it smaller
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  // color: Color.fromRGBO(7, 15, 43, 0),
                  color: Colors.blue.shade700,
                ),
                SizedBox(height: 2.0.w),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'Connecting to: ${device.name}',
                      style:
                          TextStyle(fontFamily: 'Aldrich', fontSize: 12.0.sp),
                    )),
              ],
            ),
          ),
        );
      },
    );
    _connectToDevice(device);
  }
}
