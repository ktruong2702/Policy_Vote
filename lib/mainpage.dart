import 'package:bai3/model/my_user.dart';
import 'package:bai3/page/defaultwidget.dart';
import 'package:bai3/page/detail.dart';
import 'package:bai3/page/home.dart';
import 'package:bai3/page/polls.dart';
import 'package:bai3/page/recentPoll.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  final MyUser user;

  const Mainpage({Key? key, required this.user}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  String selectedQuestion = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    switch (index) {
      case 0:
        {
          return const PollHomePage();
        }
      case 1:
        {
          return HomePage(user: widget.user);
        }
      case 2:
        {
          return const RecentPollPage();
        }
      case 3:
        {
          return UserDetailPage(
              user: widget.user,
              uid: widget.user
                  .uid); // Sử dụng widget.user để truy cập vào đối tượng người dùng được truyền từ Mainpage
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
        unselectedItemColor: const Color.fromARGB(255, 170, 159, 218),
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
