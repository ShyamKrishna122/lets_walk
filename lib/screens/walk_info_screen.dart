import 'package:flutter/material.dart';
import 'package:lets_walk/providers/user_model.dart';
import 'package:lets_walk/providers/walk_model.dart';
import 'package:provider/provider.dart';

class WalkInfoScreen extends StatelessWidget {
  static const routeName = "/walk_info_screen";
  const WalkInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walkModel = Provider.of<Walk>(context, listen: false).walkList;
    final user = Provider.of<User>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.userName,
        ),
      ),
      body: ListView.builder(
        itemCount: walkModel.length,
        itemBuilder: (context, index) {
          final item = walkModel[index];
          return ListTile(
            title: Text(
              '${item.numOfSteps.toString()} Steps',
            ),
            subtitle: Text(
              '${item.distance.toStringAsFixed(2)} Km',
            ),
            trailing: Text(
              '${item.calorie.toStringAsFixed(2)} Calories',
            ),
          );
        },
      ),
    );
  }
}
