import 'package:after_layout/after_layout.dart';
import 'package:app/components/menuBar.dart';
import 'package:app/globals.dart';
import 'package:app/views/middleColumn.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

class MainView extends StatefulWidget {
  MainView() : super();

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with AfterLayoutMixin<MainView> {
  bool showMenuBar = false;
  CarouselController buttonCarouselController = CarouselController();

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      showMenuBar = true;
    });
  }

  void setPage(int page) {
    buttonCarouselController.animateToPage(page, duration: panelTransition, curve: Curves.easeInOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 400,
          child: CarouselSlider(
            carouselController: buttonCarouselController,
            items: [
              Column(
                children: [
                  Expanded(
                    child: Text('LEFT'),
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: MiddleColumn(),
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: Text('RIGHT'),
                  ),
                ],
              )
            ],
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                initialPage: 1),
          ),
        ),
        AnimatedPositioned(
            bottom: showMenuBar ? 50 : -50,
            curve: Curves.easeInOutQuart,
            left: 100,
            right: 100,
            child: MenuBar(setPage: setPage),
            duration: panelTransition)
      ],
    );
  }
}
