import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/components/menuBar.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/screens/settings.dart';
import 'package:spend_spent_spent/views/leftColumn.dart';
import 'package:spend_spent_spent/views/middleColumn.dart';
import 'package:spend_spent_spent/views/rigtColumn.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainView extends StatefulWidget {
  MainView() : super();

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with AfterLayoutMixin<MainView> {
  bool showMenuBar = false;
  CarouselController buttonCarouselController = CarouselController();
  MenuBar? menuBar;
  int page = 1;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      menuBar = MenuBar(setPage: setPage, page: page);
      showMenuBar = true;
    });
  }

  void setPage(int page) {
    buttonCarouselController.animateToPage(page, duration: panelTransition, curve: Curves.easeInOutQuart);
  }

  void openSettings(context) {
    Navigator.push(context, platformPageRoute(context: context, builder: (context) => SettingsScreen()));
  }

  void onPageChanged(int page, CarouselPageChangedReason reason) {
    setState(() {
      this.page = page;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 67.0),
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              items: [
                Column(
                  children: [
                    Expanded(
                      child: LeftColumn(),
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
                      child: RightColumn(),
                    ),
                  ],
                )
              ],
              options: CarouselOptions(height: MediaQuery.of(context).size.height, enableInfiniteScroll: false, viewportFraction: 1,  onPageChanged: onPageChanged, initialPage: 1),
            ),
          ),
        ),
        AnimatedPositioned(bottom: showMenuBar ? 15 : -15, curve: Curves.easeInOutQuart, left: 100, right: 100, child: MenuBar(setPage: setPage, page: page), duration: panelTransition),
        Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.cog,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => openSettings(context),
            ))
      ],
    );
  }
}
