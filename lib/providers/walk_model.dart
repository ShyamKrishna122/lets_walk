import 'package:flutter/cupertino.dart';

class WalkModel {
  String userName;
  DateTime walkingDuration;
  int numOfSteps;
  double distance;
  double calorie;

  WalkModel({
    required this.userName,
    required this.walkingDuration,
    required this.numOfSteps,
    required this.distance,
    required this.calorie,
  });
}

class Walk extends ChangeNotifier {
  List<WalkModel> _walkList = [];

  void addWalkInfo({required WalkModel walkModel}) {
    _walkList.add(walkModel);
    notifyListeners();
  }

  List<WalkModel> get walkList => _walkList;
}
