import 'package:carrot_market_sample/page/testwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:carrot_market_sample/page/home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  //body 위젯 생성
  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
        break;
      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return TestWidget();
        break;
    }
    return Container();
  }

  //bottom bar item 함수
  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        "assets/svg/${iconName}_off.svg",
        width: 22,
      ),
      activeIcon: SvgPicture.asset(
        "assets/svg/${iconName}_on.svg",
        width: 22,
      ),
      label: label,
    );
  }

  // bottom navigation bar 위젯 생성
  Widget _bottomNavgationBarwidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      selectedFontSize: 12,
      currentIndex: _currentPageIndex,
      //selectedItemColor: Color.fromARGB(255, 254, 0, 0),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      items: [
        _bottomNavigationBarItem("home", "Home"),
        _bottomNavigationBarItem("notes", "Notes"),
        _bottomNavigationBarItem("location", "Location"),
        _bottomNavigationBarItem("chat", "Chat"),
        _bottomNavigationBarItem("user", "User"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavgationBarwidget(),
    );
  }
}
