import 'package:central_music/pages/add_publication.dart';
import 'package:central_music/pages/chats_page.dart';
import 'package:central_music/pages/grid_widget.dart';
import 'package:central_music/pages/user_edit_page.dart';
import 'package:central_music/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarController extends StatefulWidget {

  @override
  _BottomNavigationBarControllerState createState() => _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState extends State<BottomNavigationBarController> {
  final List<Widget> pages = [

    GridWidget(
      key: PageStorageKey('Page1'),
    ),
    SecondPage(
      key: PageStorageKey('Page2'),
    ),
    ChatsPage(
      key: PageStorageKey('Page3'),
    ),
    UserProfileScreen(
      key: PageStorageKey('Page3'),
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
          icon: Icon(Icons.home,color:Colors.black), title: Text('Anúncios', style: TextStyle(color: Colors.black),)),
      BottomNavigationBarItem(
          backgroundColor:Colors.black,
          icon: Icon(Icons.add,color:Colors.black), title: Text('Criar Anúncio', style: TextStyle(color: Colors.black),)),
      BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outlined,color:Colors.black), title: Text('Chat', style: TextStyle(color: Colors.black),)),
      BottomNavigationBarItem(
          icon: Icon(Icons.person,color:Colors.black), title: Text('Perfil', style: TextStyle(color: Colors.black),)),
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