import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/state/add_recurring_expense.dart';

const Map<int, String> TYPES = {0: 'Daily', 1: 'Weekly', 2: 'Monthly', 3: 'Yearly'};
const Map<int, String> WEEKLY_PARAMS = {
  2: 'Monday',
  3: 'Tuesday',
  4: 'Wednesday',
  5: 'Thursday',
  6: 'Friday',
  7: 'Saturday',
  1: 'Sunday',
};
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

class Step2 extends StatelessWidget {
  final int? type, typeParam;
  final DateTime? firstOccurrence;
  final Function setType, setTypeParam;
  final void Function(DateTime) setFirstOccurrence;

  const Step2({
    super.key,
    required this.setType,
    required this.setTypeParam,
    required this.setFirstOccurrence,
    this.type,
    this.typeParam,
    this.firstOccurrence,
  });

  Future<void> selectFirstOccurrence(BuildContext context) async {
    final range = firstOccurrenceRange(firstOccurrence, DateTime.now());
    final date = await showDatePicker(
      context: context,
      // the next yearly occurrence can be today, the 29th or later, which can't be chosen
      initialDate: isOnSchedule(type!, typeParam ?? 0, firstOccurrence!) ? firstOccurrence : null,
      firstDate: range.first,
      lastDate: range.last,
      selectableDayPredicate: (date) => isOnSchedule(type!, typeParam ?? 0, date),
    );
    if (date != null) {
      setFirstOccurrence(date);
    }
  }

  Map<int, String> get typeParams => switch (type) {
    1 => WEEKLY_PARAMS,
    2 => MONTHLY_PARAMS,
    3 => YEARLY_PARAMS,
    _ => {},
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
                  .map(
                    (index, e) => MapEntry(
                      index,
                      GestureDetector(
                        onTap: () => setType(index),
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            borderRadius: defaultBorder,
                            color: (type ?? -1) != index ? Colors.transparent : colors.primaryContainer,
                          ),
                          duration: panelTransition,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 15,
                                color: (type ?? -1) == index ? colors.onPrimaryContainer : colors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
          Visibility(
            visible: (type ?? -1) > 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4,
                children: typeParams
                    .map(
                      (index, e) => MapEntry(
                        index,
                        GestureDetector(
                          onTap: () => setTypeParam(index),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              borderRadius: defaultBorder,
                              color: (typeParam ?? -1) != index ? Colors.transparent : colors.primaryContainer,
                            ),
                            duration: panelTransition,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: (typeParam ?? -1) == index ? colors.onPrimaryContainer : colors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          ),
          if (firstOccurrence != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('First payment', style: TextStyle(color: colors.secondary)),
                TextButton(
                  onPressed: () => selectFirstOccurrence(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(firstOccurrence!)),
                ),
              ],
            ),
            if (firstOccurrence!.isBefore(DateUtils.dateOnly(DateTime.now())))
              Text(
                // the background job runs every 100 minutes
                'Already past, the payments up to today are added within two hours',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.secondary, fontSize: 12),
              ),
          ],
        ],
      ),
    );
  }
}
