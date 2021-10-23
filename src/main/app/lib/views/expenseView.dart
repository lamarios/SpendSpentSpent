import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class ExpenseView extends StatefulWidget {
  Expense expense;

  ExpenseView(this.expense);

  @override
  ExpenseViewState createState() => ExpenseViewState();
}

class ExpenseViewState extends State<ExpenseView> {
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
                  child: PlatformText(
                    'Cancel',
                    style: TextStyle(color: colors.cancelText),
                  ),
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
                    deleteExpense(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  deleteExpense(BuildContext context) async {
    await service.deleteExpense(widget.expense.id!);
    Navigator.pop(context);
  }

  Widget getRepeatedIcon(AppColors colors) {
    List<Widget> icons = [];

    for (int i = 0; i < 150; i++) {
      icons.add(getIcon(widget.expense.category.icon!, color: colors.text, size:40));
    }

    return Opacity(
      opacity: 0.03,
      child: Wrap(
        children: icons,
        spacing: 20,
        runSpacing: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Stack(
      children: [
        Visibility(
            visible: !hasLocation(),
            child: Positioned(
              top: -20,
              left: -30,
              right: -30,
              bottom: -20,
              child: getRepeatedIcon(colors),
            )),
        Visibility(
          visible: hasLocation(),
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
              child: FlutterMap(
                options: MapOptions(center: LatLng((widget.expense.latitude ?? 0) - 0.013, widget.expense.longitude ?? 0), zoom: 15),
                layers: [
                  TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: [
                    Marker(
                        width: 40.0,
                        height: 40.0,
                        point: new LatLng(widget.expense.latitude ?? 0, widget.expense.longitude ?? 0),
                        builder: (ctx) => FaIcon(
                              FontAwesomeIcons.mapMarkerAlt,
                              color: colors.main,
                              size: 50,
                            ))
                  ])
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => showDeleteExpenseDialog(context),
                  child: Container(
                    child: FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            )),
        Positioned(
            top: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: hasLocation()?colors.dialogBackground: Colors.transparent, borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.times,
                        color: colors.text,
                        size: 15,
                      ),
                    ),
                  ),
                )
              ],
            )),
        Positioned(
          top: 0,
          bottom: 70,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: getIcon(widget.expense.category.icon!, color: colors.iconOnMain, size: 50),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colors.main),
                width: 100,
                alignment: Alignment.center,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: defaultBorder,
                    color: hasLocation() ? colors.dialogBackground: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Text(
                      formatCurrency(widget.expense.amount),
                      style: TextStyle(fontSize: 50, color: colors.text, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: hasNote(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(borderRadius: defaultBorder, color: colors.announcement),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                        child: Text(widget.expense.note ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: colors.announcementText)),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
