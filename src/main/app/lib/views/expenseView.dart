import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/expense.dart';

class ExpenseView extends StatelessWidget {
  final Expense expense;

  const ExpenseView(this.expense, {super.key});

  bool hasLocation() {
    return expense.longitude != 0 && expense.latitude != 0;
  }

  bool hasNote() {
    return (expense.note?.length ?? 0) > 0;
  }

  showDeleteExpenseDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: const Text('Delete Expense ?'),
              content: const Text(
                  'This will only delete this expense, it is not recoverable.'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText(
                    'Cancel',
                    style: TextStyle(color: colors.secondary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PlatformDialogAction(
                  child: PlatformText(
                    'Delete',
                    style: const TextStyle(color: Colors.red),
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
    await service.deleteExpense(expense.id!);
    Navigator.pop(context);
  }

  Widget getRepeatedIcon(ColorScheme colors) {
    List<Widget> icons = [];

    for (int i = 0; i < 150; i++) {
      icons.add(
          getIcon(expense.category.icon!, color: colors.onSurface, size: 40));
    }

    return Opacity(
      opacity: 0.03,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: icons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Colors.white),
              child: FlutterMap(
                options: MapOptions(
                    initialZoom: 15,
                    initialCenter: LatLng((expense.latitude ?? 0) - 0.013,
                        expense.longitude ?? 0)),
                children: [
                  TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.spendspentspent.app',
                      retinaMode:
                          MediaQuery.of(context).devicePixelRatio > 1.0),
                  MarkerLayer(markers: [
                    Marker(
                        width: 40.0,
                        height: 40.0,
                        point: new LatLng(
                            expense.latitude ?? 0, expense.longitude ?? 0),
                        child: FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: colors.primary,
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
                    child: const FaIcon(
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
                    decoration: BoxDecoration(
                        color: hasLocation()
                            ? colors.surfaceContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        color: colors.onSurface,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: colors.primaryContainer),
                width: 100,
                alignment: Alignment.center,
                height: 100,
                child: getIcon(expense.category.icon!,
                    color: colors.onPrimaryContainer, size: 50),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: defaultBorder,
                    color: hasLocation()
                        ? colors.surfaceContainer
                        : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: Text(
                      formatCurrency(expense.amount),
                      style: TextStyle(
                          fontSize: 50,
                          color: colors.onSurface,
                          fontWeight: FontWeight.w300),
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
                      decoration: BoxDecoration(
                          borderRadius: defaultBorder,
                          color: colors.tertiaryContainer),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Text(expense.note ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                color: colors.onTertiaryContainer)),
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
