import 'package:flutter/material.dart';
import 'package:newsapp/src/pages/tab1_page.dart';
import 'package:newsapp/src/pages/tab2_page.dart';

import 'package:provider/provider.dart';

class TabsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _NavigatorProvider(),
      child: Scaffold(
        body: _Pages(),
        bottomNavigationBar: _BottomNavigationBar(),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigatorModel = context.watch<_NavigatorProvider>();

    return BottomNavigationBar(
        currentIndex: navigatorModel.pageCurrent,
        onTap: (i) => navigatorModel.pageCurrent = i,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Para ti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Encabezados',
          ),
        ]);
  }
}

class _Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigatorModel = Provider.of<_NavigatorProvider>(context);

    return PageView(
      controller: navigatorModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Tab1Page(),
        Tab2Page(),
      ],
    );
  }
}

class _NavigatorProvider with ChangeNotifier {
  int _pageCurrent = 0;
  PageController _pageController = new PageController();

  int get pageCurrent => this._pageCurrent;

  set pageCurrent(int valor) {
    this._pageCurrent = valor;

    _pageController.animateToPage(valor,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyListeners();
  }

  PageController get pageController => this._pageController;
}
