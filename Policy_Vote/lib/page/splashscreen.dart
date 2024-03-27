import 'package:flutter/material.dart';
import 'package:bai3/page/Voter/register.dart';
import 'package:bai3/page/login.dart';
import 'package:bai3/mainpage.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
                size:
                    150), // Logo của Flutter, bạn có thể thay thế bằng hình ảnh logo của bạn
            const SizedBox(height: 50),
            // Title Here
            const Text("Welcom to Policy Vote"),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nút đăng nhập được nhấn
                  // Navigator để điều hướng tới trang RegisterPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginForm()),
                );
              },
               style: ButtonStyle(
                // Đặt padding để làm cho nút rộng và dài ra
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                ),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                // Navigator để điều hướng tới trang RegisterPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
              style: ButtonStyle(
                // Đặt padding để làm cho nút rộng và dài ra
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                ),
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 20),

              OutlinedButton(
              onPressed: () {
                // Navigator để điều hướng tới trang RegisterPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Mainpage()),
                );
              },
              style: ButtonStyle(
                // Đặt padding để làm cho nút rộng và dài ra
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                ),
              ),
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
