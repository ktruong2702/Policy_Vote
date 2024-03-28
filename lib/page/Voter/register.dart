import 'package:bai3/model/user.dart';
import 'package:bai3/page/detail.dart';
import 'package:flutter/material.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _checkvalue_1 = false;
  bool _checkvalue_2 = false;
  bool _checkvalue_3 = false;

  int _gender = 0;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
       return Scaffold(
        appBar: AppBar(
        ),
        
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
                const SizedBox(height: 16),
                const Text("Whate is your Gender?"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child:ListTile(
                        title: const Text("Male"),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Transform.translate(
                          offset: const Offset(16, 0),
                          child: Radio(
                          value: 1,
                          groupValue: _gender,
                          onChanged: (value){
                            setState(() {
                              _gender = value!;
                            });
                          },
                          ),
                        ),
                      ),
                    ),
                      Expanded(
                      child:ListTile(
                        title: const Text("Female"),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Transform.translate(
                          offset: const Offset(16, 0),
                          child: Radio(
                          value: 2,
                          groupValue: _gender,
                          onChanged: (value){
                            setState(() {
                              _gender = value!;
                            });
                          },
                          ),
                        ),
                      ),
                    ),
                      Expanded(
                      child:ListTile(
                        title: const Text("other"),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Transform.translate(
                          offset: const Offset(16, 0),
                          child: Radio(
                          value: 3,
                          groupValue: _gender,
                          onChanged: (value){
                            setState(() {
                              _gender = value!;
                            });
                          },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:  16),
                const Text("What is your Favorite?"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text("Music"),
                        value: _checkvalue_1,
                        onChanged: (value){
                          setState(() {
                           _checkvalue_1 = value!;
                           
                          });
                        },
                      ),
                    ),
                     Expanded(
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text("Movie"),
                        value: _checkvalue_2,
                        onChanged: (value){
                          setState(() {
                          _checkvalue_2 = value!;
                           
                          });
                        },
                      ),
                    ),
                     Expanded(
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.all(0),
                        title: const Text("Book"),
                        value: _checkvalue_3,
                        onChanged: (value){
                          setState(() {
                          _checkvalue_3 = value!;
                           
                          });
                        },
                        ),
                    ),
                  ],
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

          // Lấy giới tính
          var genderName = 'None';
          if (_gender == 1) {
            genderName = 'Male';
          } else if (_gender == 2) {
            genderName = 'Female';
          } else {
            genderName = 'Other';
          }

          // Lấy sở thích
          var favoriteName = '';
          if (_checkvalue_1) {
            favoriteName += 'Music, ';
          }
          if (_checkvalue_2) {
            favoriteName += 'Movie, ';
          }
          if (_checkvalue_3) {
            favoriteName += 'Book, ';
          }
if (favoriteName != "") {
  favoriteName = favoriteName.substring(0, favoriteName.length - 2);
}


var objUser = User(
  fullname: fullName,
  email: email,
  gender: genderName,
  favorite: favoriteName,
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
    Expanded(child: OutlinedButton(onPressed: (){},
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