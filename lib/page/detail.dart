import 'package:bai3/model/my_user.dart';
import 'package:bai3/page/splashscreen.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({Key? key, required this.user}) : super(key: key);

  final MyUser user;

  @override
  Widget build(BuildContext context) {
    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontFamily: 'PTSerif',
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(230, 68, 71, 245),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage('https://i.imgur.com/0X4O98q.png'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    'Full name',
                    style: mystyle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    'Email', 
                    style: mystyle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.logout, color: Colors.black),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                    },
                    child: const Text('Log out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
