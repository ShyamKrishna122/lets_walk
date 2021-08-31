import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_walk/providers/user_model.dart';
import 'package:lets_walk/providers/walk_model.dart';
import 'package:lets_walk/screens/walk_info_screen.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/main_screen";
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '';
  int _steps = 0;
  int _previousSteps = 0;
  double previousKm = 0.00;
  double previousCal = 0.00;
  DateTime _walkTime = DateTime.now();
  DateTime _walkStartTime = DateTime.now();
  bool _isPlaying = false;
  double _km = 0.0;
  double _calories = 0.0;

  double _temp = 0.0;
  double _convert = 0.0;
  double _kmx = 0.0;

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.activityRecognition,
    ].request();
    return statuses[Permission.activityRecognition] == PermissionStatus.granted;
  }

  void onStepCount(StepCount event) {
    if (_isPlaying) {
      setState(() {
        _steps = event.steps - _previousSteps;
        _walkTime = event.timeStamp;
      });
      var dist = event.steps;
      double y = (dist + .0);

      setState(() {
        _temp = y;
      });

      num long3 = (_temp);
      long3 = num.parse(y.toStringAsFixed(2));
      var long4 = (long3 / 10000);

      int decimals = 1;
      num fac = pow(10, decimals);
      double d = long4;
      d = (d * fac).round() / fac;

      getDistanceRun(_temp);

      setState(() {
        _convert = d;
      });
    } else {
      _km = 0.00;
      _steps = 0;
    }
  }

  void getDistanceRun(double _numerox) {
    double distance = ((_numerox * 78) / 100000);
    distance = distance;
    var distancekmx = distance * 34;
    distancekmx = distancekmx;
    setState(() {
      _km = distance - previousKm;
    });
    setState(() {
      _kmx = distancekmx;
    });
  }

  void getBurnedRun() {
    setState(() {
      if (_isPlaying) {
        var calories = _kmx;
        _calories = calories - previousCal;
      } else {
        _calories = 0;
      }
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void initializePedometer() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  @override
  void dispose() {
    _stepCountStream.listen(onStepCount).cancel();
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getBurnedRun();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Walk',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(WalkInfoScreen.routeName);
            },
            icon: Icon(
              Icons.info,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/step.png",
              height: 100,
              width: 100,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            _steps.toString(),
            style: TextStyle(
              color: Colors.blue[900],
              fontSize: 40,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Steps",
            style: TextStyle(
              color: Colors.blue[900],
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 150,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoWidget(
                  infoImage: "assets/distance.png",
                  info: _km.toStringAsFixed(2),
                ),
                InfoWidget(
                  infoImage: "assets/distance.png",
                  info: DateFormat.Hms().format(_walkTime),
                ),
                InfoWidget(
                  infoImage: "assets/burnedx.png",
                  info: "${_calories.toStringAsFixed(2)} Calories",
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          CircleAvatar(
            radius: 40,
            child: IconButton(
              onPressed: () {
                if (_isPlaying) {
                  setState(() {
                    _previousSteps = _steps;
                    previousKm = _km;
                    previousCal = _calories;
                  });
                  saveInfo();
                  setState(() {
                    _isPlaying = false;
                  });
                } else {
                  _checkPermission().then((granted) {
                    if (!granted) return;
                    initializePedometer();
                  });
                  setState(() {
                    _walkStartTime = DateTime.now();
                    _isPlaying = true;
                  });
                }
              },
              icon: _isPlaying
                  ? Icon(
                      Icons.stop,
                      size: 35,
                    )
                  : Icon(
                      Icons.play_arrow,
                      size: 35,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void reset() {
    setState(() {
      _steps = 0;
      _km = 0.00;
      _calories = 0.00;
    });
  }

  void saveInfo() {
    Provider.of<Walk>(context, listen: false).addWalkInfo(
        walkModel: WalkModel(
      userName: Provider.of<User>(context, listen: false).user.userName,
      walkingDuration: _walkTime,
      numOfSteps: _steps,
      distance: _km,
      calorie: _calories,
    ));
    reset();
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    Key? key,
    required this.infoImage,
    required this.info,
  }) : super(key: key);

  final String infoImage;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          infoImage,
          height: 100,
          width: 100,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          info,
          style: TextStyle(
            color: Colors.blue[900],
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
