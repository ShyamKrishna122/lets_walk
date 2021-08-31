import 'package:flutter/material.dart';
import 'package:lets_walk/providers/user_model.dart';
import 'package:lets_walk/providers/walk_model.dart';
import 'package:lets_walk/screens/login_screen.dart';
import 'package:lets_walk/screens/main_screen.dart';
import 'package:lets_walk/screens/splash_screen.dart';
import 'package:lets_walk/screens/walk_info_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => User(),
        ),
        ChangeNotifierProvider(
          create: (context) => Walk(),
        ),
      ],
      child: MaterialApp(
          title: 'Let\'s Walk',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            WalkInfoScreen.routeName: (ctx) => WalkInfoScreen(),
          }),
    );
  }
}
