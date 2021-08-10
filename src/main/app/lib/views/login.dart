import 'package:app/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login() : super();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: globals.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: globals.accentColor,
                borderRadius: globals.defaultBorder,
              ),
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [TextField()],
                  )),
            )
          ],
        ));
  }
}
