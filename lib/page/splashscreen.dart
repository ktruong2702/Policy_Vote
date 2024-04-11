import 'package:bai3/page/Voter/register.dart';
import 'package:bai3/page/login.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox (
              width: 500,
              height: 200,
              child: Image.network('https://i.imgur.com/mNal8yG.jpeg'),
            ),
            const SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to Policy Vote",
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the text bold
                      fontFamily: 'PTSerif', // Set font family to Montserrat
                      // You can also add more styling properties such as color, etc.
                    ),
                  ),
                  SizedBox(height: 10), // Adjust spacing between the two lines
                  Text(
                    "Empowering Every Voice – Your Gateway to Effortless Voting Access",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Adjust the font size as needed
                      fontFamily: 'PTSerif', // Set font family to Montserrat
                      // You can also add more styling properties such as color, etc.
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginForm()),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(171, 170, 159, 218)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text('  Login  '),
          ),
            const SizedBox(height: 20),

            ElevatedButton(
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
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(171, 170, 159, 218)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 20),

            //   ElevatedButton(
            //   onPressed: () {
            //     // Navigator để điều hướng tới trang RegisterPage
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Mainpage(user: user)),
            //     );
            //   },
            //   style: ButtonStyle(
            //     // Đặt padding để làm cho nút rộng và dài ra
            //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            //       const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
            //     ),
            //     backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(171, 170, 159, 218)!),
            //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            //   ),
            //   child: const Text('  Home  '),
            // ),
          ],
        ),
      ),
    );
  }
}
