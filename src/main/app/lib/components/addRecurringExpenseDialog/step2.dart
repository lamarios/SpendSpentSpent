import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

const Map<int, String> TYPES = {0: 'Daily', 1: 'Weekly', 2: 'Monthly', 3: 'Yearly'};
const Map<int, String> WEEKLY_PARAMS = {2: 'Monday', 3: 'Tuesday', 4: 'Wednesday', 5: 'Thursday', 6: 'Saturday', 1: 'Sunday'};
const Map<int, String> MONTHLY_PARAMS = {
  1: '1',
  2: '2',
  3: '3',
  4: '4',
  5: '5',
  6: '6',
  7: '7',
  8: '8',
  9: '9',
  10: '10',
  11: '11',
  12: '12',
  13: '13',
  14: '14',
  15: '15',
  16: '16',
  17: '17',
  18: '18',
  19: '19',
  20: '20',
  21: '21',
  22: '22',
  23: '23',
  24: '24',
  25: '25',
  26: '26',
  27: '27',
  28: '28',
};
const Map<int, String> YEARLY_PARAMS = {
  0: 'January',
  1: 'February',
  2: 'March',
  3: 'April',
  4: 'May',
  5: 'June',
  6: 'July',
  7: 'August',
  8: 'September',
  9: 'October',
  10: 'November',
  11: 'December',
};

class Step2 extends StatefulWidget {
  int? type, typeParam;
  Function setType, setTypeParam;

  Step2({required this.setType, required this.setTypeParam, this.type, this.typeParam});

  @override
  Step2State createState() => Step2State();
}

class Step2State extends State<Step2> {
  Map<int, String> typeParams = {};

  @override
  void didUpdateWidget(covariant Step2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      switch (widget.type) {
        case 1:
          typeParams = WEEKLY_PARAMS;
          break;
        case 2:
          typeParams = MONTHLY_PARAMS;
          break;
        case 3:
          typeParams = YEARLY_PARAMS;
          break;
        default:
          typeParams = {};
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4,
              children: TYPES
                  .map((index, e) => MapEntry(
                      index,
                      GestureDetector(
                        onTap: () => widget.setType(index),
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            borderRadius: defaultBorder,
                            color: (widget.type ?? -1) != index ? Colors.white : Theme.of(context).primaryColor,
                          ),
                          duration: panelTransition,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e, style: TextStyle(fontSize: 15, color: (widget.type ?? -1) == index ? Colors.white : Theme.of(context).primaryColor)),
                          ),
                        ),
                      )))
                  .values
                  .toList(),
            ),
          ),
          Visibility(
            visible: (widget.type ?? -1) > 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4,
                children: typeParams
                    .map((index, e) => MapEntry(
                        index,
                        GestureDetector(
                          onTap: () => widget.setTypeParam(index),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              borderRadius: defaultBorder,
                              color: (widget.typeParam ?? -1) != index ? Colors.white : Theme.of(context).primaryColor,
                            ),
                            duration: panelTransition,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e, style: TextStyle(fontSize: 15, color: (widget.typeParam ?? -1) == index ? Colors.white : Theme.of(context).primaryColor)),
                            ),
                          ),
                        )))
                    .values
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
