import 'package:flutter/material.dart';
import 'package:todoer/screens/task_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoer/widgets/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('User signed in!: $account');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskScreen(googleSignIn),
        ),
      );
    }
  }

  void login() async {
    try {
      await googleSignIn.signIn();
    } catch (e) {
      print('EXCEPTION : ${e.message}');
    }
  }

  void logout() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      print('EXCEPTION : ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.lightBlue[200],
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  todoerLogo,
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'ToDoer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 75.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  splashColor: Colors.white,
                  child: Container(
                    width: 200.0,
                    child: Image(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                    ),
                  ),
                  onTap: login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}