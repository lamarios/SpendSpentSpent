import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';

class MasterDetail extends StatefulWidget {
  final Widget master;

  const MasterDetail({super.key, required this.master});

  late final MasterDetailState state;

  setDetails(Widget details, String title, BuildContext context) {
    details = details;
    state.changeDetails(context, title, details);
  }

  @override
  MasterDetailState createState() {
    state = MasterDetailState();
    return state;
  }
}

class MasterDetailState extends State<MasterDetail> {
  Widget? detail;

  void changeDetails(BuildContext context, String title, Widget detail) {
    if (!isTablet(MediaQuery.of(context))) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    appBar: AppBar(title: Text(title)),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body: detail,
                  )));
    } else {
      setState(() {
        this.detail = detail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool tablet = isTablet(MediaQuery.of(context));
    if (tablet) {
      return Row(children: [
        SizedBox(width: 300, child: widget.master),
        Expanded(child: detail ?? Container())
      ]);
    } else {
      return widget.master;
    }
  }
}
