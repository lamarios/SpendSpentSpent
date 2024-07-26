import 'package:after_layout/after_layout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/components/menuBar.dart' as mb;
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/screens/settings.dart';
import 'package:spend_spent_spent/views/leftColumn.dart';
import 'package:spend_spent_spent/views/middleColumn.dart';
import 'package:spend_spent_spent/expenses/views/screens/right_column.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with AfterLayoutMixin<MainView> {
  bool showMenuBar = false;
  CarouselController buttonCarouselController = CarouselController();
  mb.MenuBar? menuBar;
  int page = 1;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      menuBar = mb.MenuBar(setPage: setPage, page: page);
      showMenuBar = true;
    });
  }

  void setPage(int page) {
    buttonCarouselController.animateToPage(page,
        duration: panelTransition, curve: Curves.easeInOutQuart);
  }

  void openSettings(context) {
    Navigator.push(
        context,
        platformPageRoute(
            context: context, builder: (context) => SettingsScreen()));
  }

  void onPageChanged(int page, CarouselPageChangedReason reason) {
    setState(() {
      this.page = page;
    });
  }

  double columnMaxWidth(MediaQueryData data) {
    if (isTablet(data)) {
      return TABLET;
    } else {
      return data.size.width;
    }
  }

  @override
  Widget build(BuildContext context) {
    double columnWidth = columnMaxWidth(MediaQuery.of(context));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 67.0),
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              items: [
                AnimatedContainer(
                  width: columnWidth,
                  duration: panelTransition,
                  curve: Curves.easeInOutQuart,
                  child: Column(
                    children: [
                      Expanded(
                        child: FadeIn(
                            duration: panelTransition, child: LeftColumnTab()),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  width: columnWidth,
                  duration: panelTransition,
                  curve: Curves.easeInOutQuart,
                  child: Column(
                    children: [
                      Expanded(
                        child: FadeIn(
                            duration: panelTransition,
                            child: MiddleColumnTab()),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  width: columnWidth,
                  duration: panelTransition,
                  curve: Curves.easeInOutQuart,
                  child: const Column(
                    children: [
                      Expanded(
                        child: FadeIn(
                            duration: panelTransition, child: RightColumnTab()),
                      ),
                    ],
                  ),
                )
              ],
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: onPageChanged,
                  initialPage: 1),
            ),
          ),
        ),
        AnimatedPositioned(
            bottom: showMenuBar ? 15 : -15,
            left: 0,
            right: 0,
            curve: Curves.easeInOutQuart,
            duration: panelTransition,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: mb.MenuBar(setPage: setPage, page: page),
            )),
        Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.gear,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => openSettings(context),
            ))
      ],
    );
  }
}
