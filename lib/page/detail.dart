import 'package:bai3/model/my_user.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final MyUser user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'User Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(230, 68, 71, 245),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'First Name',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900], // Vintage color
                ),
              ),
              subtitle: Text(
                user.f_name,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(), // Vintage divider
            ListTile(
              title: Text(
                'Last Name',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900], // Vintage color
                ),
              ),
              subtitle: Text(
                user.l_name,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(), // Vintage divider
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900], // Vintage color
                ),
              ),
              subtitle: Text(
                user.email,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(), // Vintage divider
            ListTile(
              title: Text(
                'Username',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900], // Vintage color
                ),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
