import 'package:bai3/page/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _f_nameController = TextEditingController();
  final _l_nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Function to register user and save data to Firebase
  Future<void> _register() async {
    try {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        // Show error message if passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _usernameController.text)
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Show error message if username already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The username is already in use by another account')),
        );
        return;
      }
      // Register user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'f_name': _f_nameController.text
            .split(" ")
            .first, // Assuming first part is first name
        'l_name': _l_nameController.text
            .split(" ")
            .last, // Assuming last part is last name
        'reg': Timestamp.now(),
        'password': _passwordController.text,
        'username': _usernameController.text,
      });

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
    } catch (error) {
      // Handle registration errors
      if (error is FirebaseAuthException && error.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email address is badly formatted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), //shifting all upward
        child: Center(
          child: SingleChildScrollView(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'PTSerif',
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 84, 78, 110),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _f_nameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      icon: Icon(Icons.person_add),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _l_nameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      icon: Icon(Icons.person_add_alt_1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      icon: Icon(Icons.person_outline_sharp),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _register,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>
                              (const Color.fromARGB(255, 150, 136, 214),),
                          foregroundColor:
                              MaterialStateProperty.all<Color>
                              (Colors.white),
                        ),
                        child: const Text('Register'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginForm()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>
                              (const Color.fromARGB(255, 155, 133, 255),),
                          foregroundColor:
                              MaterialStateProperty.all<Color>
                              (Colors.white),
                        ),
                        child: const Text(' Login '),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _f_nameController.dispose();
    _l_nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
