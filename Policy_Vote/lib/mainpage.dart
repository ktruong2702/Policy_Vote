import 'package:bai3/page/createPoll.dart';
import 'package:bai3/page/defulatwidget.dart';
import 'package:bai3/page/login.dart';
import 'package:bai3/page/splashscreen.dart';
import 'package:flutter/material.dart';
import 'page/Voter/register.dart';
import 'page/Voter/contact.dart';
import 'package:bai3/page/polls.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "SplashScreen";
    switch (index) {
      case 0:
        {
          return const PollPage();
        }
      case 1:
        nameWidgets = "Info";
        break;
      case 2:
        nameWidgets = "Info";
        break;
      case 3:
        {
          nameWidgets = "Info";
          break;
        }

      case 4:
        {
          return const SplashScreen();
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://googleflutter.com/sample_image.jpg'),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('Trần Gia Ân'),
                Text('H@st.huflit.edu.vn'),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _selectedIndex = 0;
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
              _selectedIndex = 1;
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: const Text('Info'),
            onTap: () {
              Navigator.pop(context);
              _selectedIndex = 2;
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('register'),
            onTap: () {
              Navigator.pop(context);
              _selectedIndex = 3;
              setState(() {});
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('logout'),
            onTap: () {
              Navigator.push(context ,   
              MaterialPageRoute(builder: (context) => const LoginForm()),
              );
            },
          ),
        ],
      )),
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
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
