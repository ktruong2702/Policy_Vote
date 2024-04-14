import 'package:bai3/mainpage.dart';
import 'package:bai3/model/my_user.dart';
import 'package:bai3/page/CreatorPoll/mainpageCreator.dart';
import 'package:bai3/page/admin/mainpageAdmin.dart';
import 'package:bai3/page/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _forgotPassword() async {
    String email = _emailController.text;
    try {
      // Check if the entered email exists in the Firestore collection
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        // If the email exists, send a password reset email using Firebase Auth
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset Password Email Sent'),
            content: const Text(
                'An email with instructions to reset your password has been sent to your email address.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // If the email does not exist, show an error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email Not Found'),
            content: const Text('This email address is not registered.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error sending password reset email: $e');
      // Handle any errors that occur during the process
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred while processing your request. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _updatePasswordInFirestore(userCredential.user!.uid, password);

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      MyUser user = MyUser(
        email: userSnapshot['email'],
        f_name: userSnapshot['f_name'],
        l_name: userSnapshot['l_name'],
        username: userSnapshot['username'],
        password: userSnapshot['password'],
        uid: userCredential.user!.uid,
        role: userSnapshot['role'],
      );
      if (user.role == 'admin') {
        // Navigate to admin layout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainpageAdmin(user: user)),
        );
      } else if (user.role == 'policymaker') {
        // Navigate to policymaker layout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainpageCreator(user: user)),
        );
      } else {
        // Navigate to main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainpage(user: user)),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text(
              'Your email or password is incorrect. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updatePasswordInFirestore(
      String uid, String newPassword) async {
    try {
      // Update the 'password' field in the user's Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'password': newPassword});
    } catch (e) {
      print('Error updating password in Firestore: $e');
      // Handle error updating password in Firestore...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 150, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'PTSerif',
                color: Color.fromARGB(255, 84, 78, 110),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 25, 102, 219),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  gapPadding: 150.0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 25, 102, 219),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  gapPadding: 150.0,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 155, 133, 255),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text(' Login '),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: _forgotPassword,
              child: const Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}
