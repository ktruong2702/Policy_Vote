import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  void _createPoll() async {
    try {
      // Tạo một bản ghi mới trong bộ sưu tập polls
      var pollDoc = await FirebaseFirestore.instance.collection('polls').add({
        'title': titleController.text,
        'description': descriptionController.text,
        'expired_time': selectedExpiryDate,
      });

      print('Poll created successfully');

      // Hiển thị nút để thêm câu hỏi sau khi poll đã được tạo thành công
      setState(() {
        _showAddQuestionButton = true;
      });
    } catch (error) {
      print('Error creating poll: $error');
    }
  }

  bool _showAddQuestionButton = false;

  void _createQuestions() async {
  try {
    // Tạo một bản ghi mới trong bộ sưu tập polls
    var pollDoc = await FirebaseFirestore.instance.collection('polls').add({
      'title': titleController.text,
      'description': descriptionController.text,
      'expired_time': selectedExpiryDate,
    });

    for (var question in questions) {
      if (question.isNotEmpty) {
        // Thêm mỗi câu hỏi vào bộ sưu tập questions cùng cấp với bộ sưu tập polls
        var questionDoc = await FirebaseFirestore.instance.collection('questions').add({
          'poll_id': pollDoc.id,
          'question_txt': question,
        });

        print('Question ${questionDoc.id} added to poll ${pollDoc.id}');
      }
    }
  } catch (error) {
    print('Error creating poll: $error');
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
        title: Text('Add Poll'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Poll Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Poll Description'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Expiry Date: '),
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
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Questions:'),
            ...questions.asMap().entries.map((entry) {
              int index = entry.key;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          _updateQuestion(index, value);
                        },
                        decoration:
                            InputDecoration(labelText: 'Question ${index + 1}'),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed:
                  _showAddQuestionButton ? _createQuestions : _createPoll,
              child: Text(
                  _showAddQuestionButton ? 'Create Questions' : 'Create Poll'),
            ),
          ],
        ),
      ),
    );
  }
}
