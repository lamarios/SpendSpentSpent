import 'package:fl_chart/fl_chart.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

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
    AppColors colors = get(context);
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text('Delete Expense ?'),
              content: Text('This will only delete this expense, it is not recoverable.'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('Cancel', style: TextStyle(color: colors.cancelText),),
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
    AppColors colors = get(context);
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
                  gradient: defaultGradient(context),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          getIcon(widget.expense.category.icon!, size: 20, color: colors.iconOnMain),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              formatCurrency(widget.expense.amount),
                              style: TextStyle(color: colors.textOnMain),
                            ),
                          )),
                          Visibility(
                              visible: hasLocation(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.locationArrow,
                                  color: colors.textOnMain,
                                  size: 15,
                                ),
                              )),
                          Visibility(
                              visible: hasNote(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.commentDots,
                                  color: colors.textOnMain,
                                  size: 15,
                                ),
                              )),
                          Visibility(
                              visible: widget.expense.type == 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.redo,
                                  color: colors.textOnMain,
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
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: colors.mainDark),
                                          height: NOTE_HEIGHT,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.commentDots,
                                                  color: colors.textOnDarkMain,
                                                  size: 15,
                                                ),
                                              ),
                                              Text(
                                                widget.expense.note ?? '',
                                                style: TextStyle(color: colors.textOnDarkMain),
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
                                                      gradient: defaultGradient(context),
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
