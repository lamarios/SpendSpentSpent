import 'package:material_ui/material_ui.dart';
import 'package:spend_spent_spent/globals.dart';

class MasterDetail extends StatefulWidget {
  final Widget master;

  const MasterDetail({super.key, required this.master});

  @override
  MasterDetailState createState() => MasterDetailState();
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
          ),
        ),
      );
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
      return Row(
        children: [
          SizedBox(width: 300, child: widget.master),
          Expanded(child: detail ?? Container()),
        ],
      );
    } else {
      return widget.master;
    }
  }
}
