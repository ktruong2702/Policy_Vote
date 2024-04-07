import 'package:bai3/model/my_user.dart';
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
import 'package:bai3/model/my_user.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  String selectedQuestion = "";
  MyUser user = MyUser(fullname: '', email: '');
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
        icon: Icon(Icons.auto_graph_outlined),
        label: 'Results',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'Polls',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'History',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    currentIndex: _selectedIndex,
    selectedItemColor: Colors.purple[800],
    unselectedItemColor: Color.fromARGB(255, 170, 159, 218),
    onTap: _onItemTapped,
  ),
  body: _loadWidget(_selectedIndex),
);

  }
}
