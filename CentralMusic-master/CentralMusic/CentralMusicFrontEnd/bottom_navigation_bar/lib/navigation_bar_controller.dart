import 'package:flutter/material.dart';
import 'first_page.dart';
import 'grid_widget.dart';
import 'second_page.dart';

class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  final List<Widget> pages = [
    FirstPage(
      key: PageStorageKey('Page1'),
    ),
    SecondPage(
      key: PageStorageKey('Page2'),
    ),
    GridWidget(
      key: PageStorageKey('Page2'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    onTap: (int index) => setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.add), title: Text('First Page')),
      BottomNavigationBarItem(
          icon: Icon(Icons.list), title: Text('Second Page')),
      BottomNavigationBarItem(
          icon: Icon(Icons.more), title: Text('thrid Page')),
      BottomNavigationBarItem(
          icon: Icon(Icons.more), title: Text('thrid Page')),
      BottomNavigationBarItem(
          icon: Icon(Icons.more), title: Text('thrid Page')),


    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}