import 'package:app/globals.dart' as globals;
import 'package:app/icons.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Function onLoginSuccess;

  Login({required this.onLoginSuccess});

  @override
  _LoginState createState() => _LoginState();
}

InputDecoration getFieldDecoration(String label, String hint) {
  return InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white);
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  backgroundColor: Colors.blue[800],
  padding: EdgeInsets.symmetric(vertical: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

class _LoginState extends State<Login> {
  final urlController = TextEditingController(text: "https://exp.ftpix.com");
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  Future<void> logIn() async {
    try {
      globals.service.setUrl(urlController.text);
      var loggedIn = await globals.service
          .login(usernameController.text, passwordController.text);
      setState(() {
        error = '';
      });
      if (loggedIn) {
        FBroadcast.instance().broadcast(globals.BROADCAST_LOGGED_IN);
        print(loggedIn);
        widget.onLoginSuccess();
      }
    } catch (e) {
      setState(() {
        error = e.toString().replaceFirst("Exception: ", '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8), //color of shadow
                spreadRadius: 5, //spread radius
                blurRadius: 7, // blur radius
                offset: Offset(0, 2), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
              //you can set more BoxShadow() here
            ],
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
                stops: [0, 0.5],
                begin: Alignment.bottomCenter,
                end: Alignment.topRight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: globals.defaultBorder,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getIcon('groceries_bag',
                                  size: 200, color: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: urlController,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: getFieldDecoration(
                                    "Server", "https://exp.ftpix.com")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: usernameController,
                                autocorrect: false,
                                enableSuggestions: false,
                                decoration: getFieldDecoration(
                                    "Email", "user@example.org")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: getFieldDecoration("Password", "")),
                          ),
                          Visibility(
                            visible: error.length > 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                      style: flatButtonStyle,
                                      onPressed: logIn,
                                      child: Text('Log in')),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))),
            )
          ],
        ));
  }
}
