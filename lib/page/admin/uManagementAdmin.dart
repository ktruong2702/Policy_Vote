import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bai3/model/my_user.dart';

class UserManagementPage extends StatefulWidget {
  late final MyUser user;

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController roleController;
  late TextEditingController passwordController;
  late TextEditingController uidController;
  late String selectedRole;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    roleController = TextEditingController();
    passwordController = TextEditingController();
    uidController = TextEditingController();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    roleController.dispose();
    passwordController.dispose();
    uidController.dispose();
    super.dispose();
  }

  void updateUser(String uid) async {
    try {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      Map<String, dynamic> updatedData = {
        'f_name': firstNameController.text,
        'l_name': lastNameController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'role': selectedRole,
        'ID': uidController.text,
        'password': passwordController.text,
      };

      // Update Firestore document
      await usersCollection.doc(uid).update(updatedData);

      // Fetch the user's credentials based on the ID
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // Update the password using the fetched user's credentials
      await userCredential.user!.updatePassword(passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User information updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print('Failed to update user information: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update user information. Please try again.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Widget buildUserCard(DocumentSnapshot userDocument) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          userDocument['f_name'] + ' ' + userDocument['l_name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userDocument['email'],
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              'Role: ${userDocument['role']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Added line to display user's role
          ],
        ),
        onTap: () {
          setState(() {
            selectedRole = userDocument['role'];
          });
          uidController.text = userDocument.id;
          firstNameController.text = userDocument['f_name'];
          lastNameController.text = userDocument['l_name'];
          emailController.text = userDocument['email'];
          usernameController.text = userDocument['username'];
          passwordController.text = userDocument['password'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Edit User'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        items: ['admin', 'user', 'policymaker']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedRole = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Role',
                        ),
                      ),
                      TextFormField(
                        controller: uidController,
                        decoration: InputDecoration(labelText: 'ID'),
                        enabled: false,
                      ),
                      TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        enabled: false,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        enabled: false,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      updateUser(userDocument.id);
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'User Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSerif',
          ),
        ),
        backgroundColor: Color.fromARGB(255, 101, 83, 182),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  // Trigger filtering when the search text changes
                  // Also search by role
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name or role',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                List<DocumentSnapshot> filteredUsers =
                    snapshot.data!.docs.where((userDocument) {
                  final userName =
                      userDocument['f_name'] + ' ' + userDocument['l_name'];
                  final userRole = userDocument['role'];
                  return userName
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()) ||
                      userRole
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                }).toList();

                // Sorting the filtered users list based on the role
                filteredUsers.sort((a, b) => ['admin', 'policymaker', 'user']
                    .indexOf(a['role'])
                    .compareTo(
                        ['admin', 'policymaker', 'user'].indexOf(b['role'])));

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return buildUserCard(filteredUsers[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


