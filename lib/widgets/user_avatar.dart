import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoer/models/task_data.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({@required this.googleSignIn, @required this.taskData});

  final GoogleSignIn googleSignIn;
  final TaskData taskData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
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
      ),
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
                      await googleSignIn.signOut();
                      taskData.initialSyncNeeded = true;
                      Navigator.pop(context, true); // pop out of the dialog box
                      Navigator.pop(context, true); // pop back to login screen
                      Navigator.pop(context, true); // pop back to login screen
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
