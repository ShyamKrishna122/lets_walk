import 'package:flutter/material.dart';

class UserModel {
  String userName;
  DateTime logInTime;
  UserModel({
    required this.userName,
    required this.logInTime,
  });
}

class User extends ChangeNotifier {
  UserModel _user = UserModel(
    userName: '',
    logInTime: DateTime.now(),
  );

  void setCredentials({required String userName}) {
    _user.userName = userName;
    _user.logInTime = DateTime.now();
    notifyListeners();
  }

  UserModel get user => _user;
}
