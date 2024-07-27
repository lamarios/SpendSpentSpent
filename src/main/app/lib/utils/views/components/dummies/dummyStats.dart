import 'package:flutter/material.dart';

class DummyStats extends StatelessWidget {
  const DummyStats({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.chevron_right,
                  size: 10,
                  color: colors.surfaceContainer,
                ),
              ),
              const Spacer(),
              Text(
                '0.00',
                style: TextStyle(color: colors.surfaceContainer),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Container(
              alignment: Alignment.topLeft,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: colors.surfaceContainer),
            ),
          )
        ],
      ),
    );
  }
}
