import 'package:bai3/model/user.dart';
import 'package:bai3/page/createPoll.dart';
import 'package:bai3/page/defulatwidget.dart';
import 'package:bai3/page/home.dart';
import 'package:bai3/page/login.dart';
import 'package:bai3/page/recentPoll.dart';
import 'package:bai3/page/resultPoll.dart';
import 'package:bai3/page/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:bai3/page/polls.dart';
import 'package:bai3/page/Detail.dart';
import 'package:bai3/model/user.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  String selectedQuestion = "";
  User user = User();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    switch (index) {
      case 0:
        {
          return  PollHomePage();
        }

      case 1:
        {
          return const HomePage();
        }
      case 2:
        {
          return const RecentPollPage();
        }
      case 3:
        {
          return Detail(user: user);
        }

      default:
        return const DefaultWidget(title: "None");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  bottomNavigationBar: BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.contact_mail),
        label: 'contact',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle),
        label: 'Info',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'register',
      ),
    ],
    currentIndex: _selectedIndex,
    selectedItemColor: Colors.amber[800],
    unselectedItemColor: const Color.fromARGB(255, 238, 77, 77),
    onTap: _onItemTapped,
  ),
  body: _loadWidget(_selectedIndex),
);

  }
}
