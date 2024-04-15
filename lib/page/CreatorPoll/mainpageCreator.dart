import 'package:bai3/model/my_user.dart';
import 'package:bai3/page/CreatorPoll/createpolls.dart';
import 'package:bai3/page/CreatorPoll/detail.dart';
import 'package:bai3/page/defaultwidget.dart';
import 'package:bai3/page/detail.dart';
import 'package:flutter/material.dart';

class MainpageCreator extends StatefulWidget {
  final MyUser user;
  
  const MainpageCreator({Key? key, required this.user}) : super(key: key);

  @override
  State<MainpageCreator> createState() => _MainpageState();
}

class _MainpageState extends State<MainpageCreator> {
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

          return UpdatePollPage();

        }
      case 1:
        {
          return AddPollPage();
        }  
      case 2:
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
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create_new_folder),
            label: 'Create',
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