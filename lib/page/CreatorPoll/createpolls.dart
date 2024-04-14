import 'package:bai3/page/CreatorPoll/mainpageCreator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bai3/model/my_user.dart';

class AddPollPage extends StatefulWidget {
  @override
  _AddPollPageState createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedExpiryDate;
  List<String> questions = [];

  void _addQuestion() {
    setState(() {
      questions.add('');
    });
  }

  void _updateQuestion(int index, String newValue) {
    setState(() {
      questions[index] = newValue;
    });
  }

  void _createQuestions() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedExpiryDate == null ||
        questions.isEmpty) {
      // Show an error message on the UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all required fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Create a new record in the 'polls' collection
      var pollDoc = await FirebaseFirestore.instance.collection('polls').add({
        'title': titleController.text,
        'description': descriptionController.text,
        'expired_time': selectedExpiryDate,
      });

      for (var question in questions) {
        if (question.isNotEmpty) {
          // Add each question to the 'questions' collection under the poll
          var questionDoc =
              await FirebaseFirestore.instance.collection('questions').add({
            'poll_id': pollDoc.id,
            'question_txt': question,
          });

          print('Question ${questionDoc.id} added to poll ${pollDoc.id}');
        }
      }

      // Show a success message on the UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poll successfully created.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Clear the form after successful creation
      titleController.clear();
      descriptionController.clear();
      selectedExpiryDate = null;
      questions.clear();

      // Create an instance of MyUser
      MyUser user = MyUser(
        email: 'example@example.com',
        f_name: 'First',
        l_name: 'Last',
        username: 'username',
        password: 'password',
        role: 'user',
        uid: '12345', // Initialize with your actual uid
      );

      // Navigate to the MainpageCreator with the user object
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainpageCreator(user: user)),
      );
    } catch (error) {
      // Show an error message on the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating poll: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedExpiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedExpiryDate) {
      setState(() {
        selectedExpiryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Create Poll',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'PTSerif'),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 83, 182),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Poll Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'PTSerif'),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter poll title',
                labelStyle: TextStyle(fontFamily: 'PTSerif'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Poll Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'PTSerif'),
            ),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter poll description',
                labelStyle: TextStyle(fontFamily: 'PTSerif'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text(
                  'Expiry Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'PTSerif'),
                ),
                InkWell(
                  onTap: () {
                    _selectExpiryDate(context);
                  },
                  child: Text(
                    selectedExpiryDate != null
                        ? '${selectedExpiryDate!.day}/${selectedExpiryDate!.month}/${selectedExpiryDate!.year}'
                        : 'Select Expiry Date',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PTSerif',
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Questions:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'PTSerif'),
            ),
            Column(
              children: questions.asMap().entries.map((entry) {
                int index = entry.key;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            _updateQuestion(index, value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Question ${index + 1}',
                            labelStyle: const TextStyle(fontFamily: 'PTSerif'),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addQuestion,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(171, 170, 159, 218),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createQuestions,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(171, 170, 159, 218),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('  Create Poll   '),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
