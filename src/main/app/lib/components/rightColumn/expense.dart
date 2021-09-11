import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

const double MAP_HEIGHT = 200;
const double NOTE_HEIGHT = 30;

class OneExpense extends StatefulWidget {
  Expense expense;
  Key? key;

  OneExpense({this.key, required this.expense});

  @override
  OneExpenseState createState() => OneExpenseState();
}

class OneExpenseState extends State<OneExpense> {
  bool opened = false;
  bool showInfo = false;

  openContainer() {
    setState(() {
      opened = !opened;

      Future.delayed(panelTransition, () {
        if (opened) {
          setState(() {
            showInfo = !showInfo;
          });
        }
      });

      if (!opened) {
        showInfo = false;
      }
    });
  }

  bool hasLocation() {
    return widget.expense.longitude != 0 && widget.expense.latitude != 0;
  }

  bool hasNote() {
    return (widget.expense.note?.length ?? 0) > 0;
  }

  showDeleteExpenseDialog(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text('Delete Expense ?'),
              content: Text('This will only delete this expense, it is not recoverable.'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('Cancel', style: TextStyle(color: Colors.grey[850]),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PlatformDialogAction(
                  child: PlatformText(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    deleteExpense();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  deleteExpense() async {
    await service.deleteExpense(widget.expense.id!);
  }

  double getOpenedHeight() {
    double height = 88;
    if (hasLocation()) {
      height += MAP_HEIGHT + 16; // 16 for padding
    }

    if (hasNote()) {
      height += NOTE_HEIGHT + 16; // 16 for padding
    }

    return height;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openContainer,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                alignment: Alignment.topCenter,
                duration: panelTransition,
                curve: Curves.easeInOutQuart,
                height: opened ? getOpenedHeight() : 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          getIcon(widget.expense.category.icon!, size: 20),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              formatCurrency(widget.expense.amount),
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                          Visibility(
                              visible: hasLocation(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.locationArrow,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          Visibility(
                              visible: hasNote(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.commentDots,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          Visibility(
                              visible: widget.expense.type == 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.redo,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                        ],
                      ),
                      Visibility(
                          visible: showInfo,
                          child: FadeIn(
                              curve: Curves.easeInOutQuart,
                              duration: panelTransition,
                              child: Column(
                                children: [
                                  Visibility(
                                      visible: hasNote(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Theme.of(context).primaryColorDark),
                                          height: NOTE_HEIGHT,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.commentDots,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                              Text(
                                                widget.expense.note ?? '',
                                                style: TextStyle(color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                  Visibility(
                                      visible: hasLocation(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                          height: MAP_HEIGHT,
                                          child: FlutterMap(
                                            options: MapOptions(center: LatLng(widget.expense.latitude ?? 0, widget.expense.longitude ?? 0), zoom: 15),
                                            layers: [
                                              TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                                              MarkerLayerOptions(markers: [
                                                Marker(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  point: new LatLng(widget.expense.latitude ?? 0, widget.expense.longitude ?? 0),
                                                  builder: (ctx) => new Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                                      gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                                                    ),
                                                    child: getIcon(widget.expense.category.icon!, color: Colors.white, size: 20),
                                                  ),
                                                )
                                              ])
                                            ],
                                          ),
                                        ),
                                      )),
                                  Visibility(
                                      child: Row(
                                    children: [
                                      Expanded(
                                        child: PlatformButton(
                                          onPressed: () => showDeleteExpenseDialog(context),
                                          color: Theme.of(context).primaryColorDark,
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                                ],
                              )))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
