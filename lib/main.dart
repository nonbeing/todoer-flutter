import 'package:flutter/material.dart';
import 'package:todoer/screens/login_screen.dart';
// import 'package:todoer/screens/task_screen.dart';
import 'package:provider/provider.dart';
import 'package:todoer/models/task_data.dart';

void main() => runApp(MyApp());
// const String DefaultUsername = 'defaultUser';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskData>(
      builder: (context) => TaskData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
