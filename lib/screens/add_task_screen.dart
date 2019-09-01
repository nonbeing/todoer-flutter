import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add Task',
              style: TextStyle(fontSize: 25.0, color: Colors.lightBlue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: myController,
                    autofocus: true,
                    onSubmitted: (value) {
                      Navigator.pop(context, value.toString());
                    },
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                MaterialButton(
                  minWidth: 10.0,
                  child: Text(
                    '>',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.lightBlue,
                  onPressed: () {
                    Navigator.pop(context, myController.text);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
