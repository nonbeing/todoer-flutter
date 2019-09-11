import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoer/models/task_data.dart';
// import 'package:path/path.dart';
import 'package:flutter/services.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({@required this.googleSignIn, @required this.taskData});

  final GoogleSignIn googleSignIn;
  final TaskData taskData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: RoundAvatar(googleSignIn: googleSignIn),
      onTap: () {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Sign Out'),
                content: Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('Cancel')),
                  FlatButton(
                    onPressed: () async {
                      taskData.initialSyncNeeded = true;
                      await googleSignIn.signOut();
                      Navigator.pop(context, true); // pop out of the dialog box
                      Navigator.pop(context, true); // pop back to login screen
                      if (googleSignIn.currentUser != null) {
                        // user still signed in ?! try to sign out again
                        await googleSignIn.signOut();
                        Navigator.pop(
                            context, true); // pop back to login screen
                      } else {
                        print(
                            'DEBUG: user is not signed in. SHOULDN\'T REACH HERE! SHOULD HAVE POPPED BACK TO HOME SCREEN!');
                        print(
                            'Current route: ${ModalRoute.of(context)?.settings?.name}');
                        // SystemChannels.platform
                        //     .invokeMethod('SystemNavigator.pop');

                        // Navigator.pop(context, true); // pop back to login screen
                      }
                      // Navigator.pop(context, true); // pop back to login screen
                    },
                    child: Text('Sign Out'),
                  )
                ],
              );
            });
      },
    );
  }
}

class RoundAvatar extends StatelessWidget {
  const RoundAvatar({@required this.googleSignIn});

  final GoogleSignIn googleSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        image: googleSignIn.currentUser != null
            ? DecorationImage(
                image: NetworkImage('${googleSignIn.currentUser.photoUrl}'),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
    );
  }
}
