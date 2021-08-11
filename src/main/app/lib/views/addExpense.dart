import 'package:app/icons.dart';
import 'package:app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExpense extends StatefulWidget {
  Category category;
  final void Function() onClose;

  AddExpense({required this.category, required this.onClose});

  @override
  AddExpenseState createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.blue],
                        stops: [0, 0.5],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topRight)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Hero(
                      tag: widget.category.icon,
                      child: getIcon(widget.category.icon, size: 200)),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(height: 100, color: Colors.grey[350]))
                ],
              ),
              Row(children: [
                KeyPadButton(
                  onPress: () {},
                  child: Text('1'),
                ),
                KeyPadButton(
                  onPress: () {},
                  child: Text('2'),
                ),
                KeyPadButton(
                  onPress: () {},
                  child: Text('3'),
                ),
              ]),
            ],
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
                onPressed: widget.onClose,
                icon: FaIcon(
                  FontAwesomeIcons.times,
                  color: Colors.white,
                  size: 20,
                )),
          ),
        ],
      ),
    );
  }
}

class KeyPadButton extends StatelessWidget {
  var onPress;
  Widget child;

  KeyPadButton({required this.onPress, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Container(alignment: Alignment.center, child: child),
        onTap: onPress,
      ),
    );
  }
}
