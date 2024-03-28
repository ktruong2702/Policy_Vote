import 'package:bai3/model/user.dart';
import 'package:flutter/material.dart';


class Detail extends StatelessWidget {
  const Detail({super.key, required this.user});
  final User user;
  // khi dùng tham số truyền vao phải khai báo bien trùng tên require
  @override
  Widget build(BuildContext context) {
  // create style
  TextStyle mystyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.amber,
  );
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Fullname: ${user.fullname}", style: mystyle),
          Text("Email: ${user.email}", style: mystyle),
          Text("Gender: ${user.gender}", style: mystyle),
          Text("Favorite: ${user.favorite}", style: mystyle),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ]),
      ),
    );
  }
}