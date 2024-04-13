import 'package:bai3/model/my_user.dart';
import 'package:bai3/page/admin/detailAdmin.dart';
import 'package:bai3/page/admin/uManagementAdmin.dart';
import 'package:bai3/page/defaultwidget.dart';
import 'package:flutter/material.dart';

class MainpageAdmin extends StatefulWidget {
  final MyUser user;
  
  const MainpageAdmin({Key? key, required this.user}) : super(key: key);

  @override
  State<MainpageAdmin> createState() => _MainpageAdminState();
}

class _MainpageAdminState extends State<MainpageAdmin> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    switch (index) {
      case 0:
        {
          return UserManagementPage();
        }
      case 1:
        {
          return AdminDetailPage(user: widget.user, uid: widget.user.uid);
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
            icon: Icon(Icons.people),
            label: 'User Management',
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
