import 'package:bai3/model/my_user.dart';
import 'package:bai3/page/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailPage extends StatefulWidget {
  final MyUser user;
  final String uid;

  const UserDetailPage({Key? key, required this.user, required this.uid})
      : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool isEditing = false;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.f_name);
    lastNameController = TextEditingController(text: widget.user.l_name);
    emailController = TextEditingController(text: widget.user.email);
    usernameController = TextEditingController(text: widget.user.username);
    passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

// void updateEmail() async {
//   try {
//     // Verify the new email before updating
//     await FirebaseAuth.instance.currentUser!.updateEmail(emailController.text);

//     // If verification is successful, update email in Firestore if necessary
//     // For example:
//     // await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({'email': emailController.text});

//     // Show a success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Email updated successfully! Verification email sent to ${emailController.text}'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   } catch (error) {
//     // Handle error
//     print('Failed to update email: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to update email. Please try again.'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// }

  void updateUser() async {
    try {
      // Get a reference to the Firestore collection
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Create a map containing only the fields that the user is allowed to edit
      Map<String, dynamic> updatedData = {
        'f_name': firstNameController.text,
        'l_name': lastNameController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      };

      // Update the user document with the new information using the uid

      await usersCollection.doc(widget.user.uid).update(updatedData);

      if (isEditing) {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(passwordController.text);
      }
      // Show a success message or perform any other actions if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User information updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Handle any errors that occur during the update process
      print('Failed to update user information: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update user information. Please try again.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true, // Remove back button
        title: const Text(
          'User Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSerif'
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 83, 182),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: toggleEdit,
                icon: const Icon(Icons.edit),
              ),
            ),
            ListTile(
              title: const Text(
                'First Name',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 84, 78, 110),
                ),
              ),
              subtitle: isEditing
                  ? TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter first name',
                      ),
                    )
                  : Text(widget.user.f_name),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Last Name',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 84, 78, 110),
                ),
              ),
              subtitle: isEditing
                  ? TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter last name',
                      ),
                    )
                  : Text(widget.user.l_name),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 84, 78, 110),
                ),
              ),
              subtitle: Text(widget.user.email),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Username',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 84, 78, 110),
                ),
              ),
              subtitle: Text(widget.user.username),
            ),
            const Divider(),
            if (isEditing)
              ListTile(
                title: const Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'PTSerif',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 84, 78, 110),
                  ),
                ),
                subtitle: isEditing
                    ? TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Enter password',
                        ),
                      )
                    : Text(widget.user.password),
              ),
            if (isEditing)
              ListTile(
                title: ElevatedButton(
                  onPressed: updateUser,
                  child: const Text('Update'),
                ),
              ),
            if (!isEditing)
              ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>
                      (const Color.fromARGB(255, 155, 133, 255),),
                    foregroundColor:MaterialStateProperty.all<Color>
                      (Colors.white),
              ),
                  child: const Text('Log out'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
