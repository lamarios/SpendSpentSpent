import 'package:spend_spent_spent/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MasterDetail extends StatefulWidget {
  Widget master;
  Key key;

  MasterDetail({required this.key, required this.master});

  late MasterDetailState state;

  setDetails(Widget details, String title, BuildContext context) {
    details = details;
    state.changeDetails(context, title, details);
  }

  MasterDetailState createState() {
    this.state = MasterDetailState();
    return state;
  }
}

class MasterDetailState extends State<MasterDetail> {
  Widget? detail;

  void changeDetails(BuildContext context, String title, Widget detail) {

    if (!isTablet(MediaQuery.of(context))) {
      Navigator.push(
          context,
          platformPageRoute(
              context: context,
              builder: (context) => PlatformScaffold(
                    appBar: PlatformAppBar(title: PlatformText(title)),
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
      return Row(children: [Container(width: 300, child: widget.master), Expanded(child: detail ?? Container())]);
    } else {
      return widget.master;
    }
  }
}
