import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Mock login logic
    if (email == 'user@example.com' && password == 'password') {
      // Successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Invalid credentials
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Credentials'),
          content: const Text('Please enter valid email and password.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icon cho nút back
          onPressed: () {
            Navigator.of(context)
                .pop(); // Đóng màn hình hiện tại khi nút back được nhấn
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
              controller: _emailController,
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
              controller: _passwordController,
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
              // Modify the onPressed callback
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('polls').orderBy('title').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot pollDocument) {
                Map<String, dynamic> pollData = pollDocument.data() as Map<String, dynamic>;
                String? pollId = pollDocument.id; // Assuming poll ID is needed

                return ListTile(
                  title: Text(pollData['title']),
                  subtitle: Text(pollData['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionListPage(pollId: pollId),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class QuestionListPage extends StatelessWidget {
  final String? pollId;

  const QuestionListPage({Key? key, this.pollId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions for Poll $pollId'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('questions').where('poll_id', isEqualTo: pollId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot questionDocument) {
              Map<String, dynamic> questionData = questionDocument.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(questionData['question_txt']),
                // Add more widgets here to display other question details if needed
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

