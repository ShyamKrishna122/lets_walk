import 'package:flutter/material.dart';
import 'package:lets_walk/constants.dart';
import 'package:lets_walk/providers/user_model.dart';
import 'package:lets_walk/screens/main_screen.dart';
import 'package:lets_walk/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/step.png",
                height: 200,
                width: 200,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Let\'s Walk",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(
                left: 15,
                top: 30,
                right: 15,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ThemeColors.kDefaultPadding * 0.75,
              ),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  border: InputBorder.none,
                  errorStyle: TextStyle(
                    height: 0,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) return 'Fill this field';
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.all(
                30,
              ),
              child: PrimaryButton(
                  text: "Next",
                  press: () {
                    Provider.of<User>(context, listen: false).setCredentials(
                      userName: nameController.text.trim(),
                    );
                    Navigator.of(context).pushNamed(MainScreen.routeName);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
