import 'package:bai3/model/user.dart';
import 'package:bai3/page/detail.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final bool _checkvalue_1 = false;
  final bool _checkvalue_2 = false;
  final bool _checkvalue_3 = false;

  final int _gender = 0;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'User Information',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    icon: Icon(Icons.person),
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
                  controller: _confirmpassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm password",
                    icon: Icon(Icons.password),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Lấy giá trị
                          var fullName = _nameController.text;
                          var email = _emailController.text;
                          var objUser = User(
                            fullname: fullName,
                            email: email,
                          );

// Điều hướng đến trang chi tiết
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(user: objUser),
                            ),
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
