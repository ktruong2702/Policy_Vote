import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icon cho nút back
          onPressed: () {
            Navigator.of(context).pop(); // Đóng màn hình hiện tại khi nút back được nhấn
          },
        ),
  
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, // Thiết lập độ đậm cho chữ label
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 25, 102, 219),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ), // Độ cong của góc viền
                  gapPadding: 150.0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, // Thiết lập độ đậm cho chữ label
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 25, 102, 219),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ), // Độ cong của góc viền
                  gapPadding: 150.0,
                ),
              ),
              obscureText: true, //Hide text password
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Login Event here
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

