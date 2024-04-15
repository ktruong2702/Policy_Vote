import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePollPage extends StatefulWidget {
  @override
  _UpdatePollPageState createState() => _UpdatePollPageState();
}

class _UpdatePollPageState extends State<UpdatePollPage> {
  late List<DocumentSnapshot> _polls = [];

  @override
  void initState() {
    super.initState();
    _fetchPolls();
  }

  Future<void> _fetchPolls() async {
    try {
      final QuerySnapshot pollSnapshot = await FirebaseFirestore.instance
          .collection('polls')
          .orderBy('title')
          .get();

      final currentTime = DateTime.now();

      setState(() {
        _polls = pollSnapshot.docs.where((poll) {
          final expiryDate =
              (poll.data() as Map<String, dynamic>)['expired_time']?.toDate();
          // Return true if the poll has no expiry date or if its expiry date is in the future
          return expiryDate == null || expiryDate.isAfter(currentTime);
        }).toList();
      });
    } catch (e) {
      print('Error fetching polls: $e');
    }
  }

  void _deletePoll(String pollId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you want to delete this poll?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  // Xóa tất cả các câu hỏi liên quan đến poll
                  await _deleteQuestions(pollId);

                  // Xóa poll sau khi xóa câu hỏi thành công
                  await FirebaseFirestore.instance
                      .collection('polls')
                      .doc(pollId)
                      .delete();

                  // Sau khi xóa thành công, cập nhật lại danh sách poll
                  _fetchPolls();
                  Navigator.pop(context); // Đóng dialog xác nhận
                } catch (e) {
                  print('Error deleting poll: $e');
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog xác nhận
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

// Hàm để xóa tất cả các câu hỏi liên quan đến một poll
  Future<void> _deleteQuestions(String pollId) async {
    try {
      QuerySnapshot questionSnapshot = await FirebaseFirestore.instance
          .collection('questions')
          .where('poll_id', isEqualTo: pollId)
          .get();

      // Duyệt qua danh sách câu hỏi và xóa chúng
      questionSnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    } catch (e) {
      print('Error deleting questions: $e');
    }
  }

  void _editPoll(String pollId) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final List<TextEditingController> questionControllers = [];
    final List<String> questionIds = []; // List to store question IDs
    DateTime? selectedExpiryDate;

    try {
      // Lấy thông tin cũ của poll từ Firestore
      DocumentSnapshot pollSnapshot = await FirebaseFirestore.instance
          .collection('polls')
          .doc(pollId)
          .get();
      Map<String, dynamic> pollData =
          pollSnapshot.data() as Map<String, dynamic>;

      // Gán các giá trị cũ vào các TextEditingController
      titleController.text = pollData['title'] ?? '';
      descriptionController.text = pollData['description'] ?? '';
      selectedExpiryDate = pollData['expired_time']?.toDate();

      // Lấy thông tin câu hỏi từ Firestore dựa trên poll_id
      QuerySnapshot questionSnapshot = await FirebaseFirestore.instance
          .collection('questions')
          .where('poll_id', isEqualTo: pollId)
          .get();

      if (questionSnapshot.docs.isNotEmpty) {
        // Lấy danh sách các câu hỏi và ID của chúng
        List<String> questions = [];
        List<String> ids = [];
        questionSnapshot.docs.forEach((doc) {
          questions.add(doc['question_txt'] as String);
          ids.add(doc.id); // Lưu ID của câu hỏi
        });

        // Tạo các TextEditingController cho từng câu hỏi
        questionControllers.addAll(
            questions.map((question) => TextEditingController(text: question)));
        questionIds.addAll(ids); // Lưu các ID của câu hỏi
      } else {
        // Nếu không có câu hỏi nào, thông báo rằng không có câu hỏi
        print('No questions found for this poll.');
      }
    } catch (e) {
      print('Error fetching poll data: $e');
      // Xử lý lỗi khi lấy dữ liệu từ Firestore
      return;
    }

    // Hiển thị Dialog để chỉnh sửa thông tin poll
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Poll'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                // Hiển thị các text field cho từng câu hỏi
                ...questionControllers.asMap().entries.map((entry) {
                  int index = entry.key;
                  TextEditingController controller = entry.value;
                  String questionId =
                      questionIds[index]; // Lấy ID của câu hỏi tương ứng
                  return Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(labelText: 'Question'),
                      ),
                      SizedBox(height: 16.0),
                      // Lưu ID của câu hỏi vào hidden widget
                      Visibility(
                        visible: false,
                        child: Text(questionId),
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Expiry Date: '),
                    InkWell(
                      onTap: () {
                        _selectExpiryDate(context, selectedExpiryDate)
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              selectedExpiryDate = value;
                            });
                          }
                        });
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Thực hiện logic cập nhật poll vào Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('polls')
                      .doc(pollId)
                      .update({
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'expired_time': selectedExpiryDate,
                  });

                  // Cập nhật từng câu hỏi
                  for (int i = 0; i < questionControllers.length; i++) {
                    String questionId = questionIds[i]; // Lấy ID của câu hỏi
                    TextEditingController controller = questionControllers[i];
                    var questionRef = FirebaseFirestore.instance
                        .collection('questions')
                        .doc(questionId);
                    var questionSnapshot = await questionRef.get();

                    if (questionSnapshot.exists) {
                      // Nếu document câu hỏi đã tồn tại, thực hiện cập nhật
                      await questionRef.update({
                        'question_txt': controller.text,
                        'poll_id': pollId,
                      });
                    } else {
                      // Nếu document không tồn tại, tạo mới document với dữ liệu mới
                      await questionRef.set({
                        'question_txt': controller.text,
                        'poll_id': pollId,
                      });
                    }
                  }

                  // Cập nhật lại danh sách poll sau khi chỉnh sửa thành công
                  _fetchPolls();
                  Navigator.pop(
                      context); // Đóng dialog sau khi cập nhật thành công
                } catch (e) {
                  print('Error updating poll: $e');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Polls Edit',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'PTSerif'),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 83, 182),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _polls.length,
        itemBuilder: (context, index) {
          final poll = _polls[index];
          final pollId = poll.id;
          final pollData = poll.data() as Map<String, dynamic>;
          final pollTitle = pollData['title'] ?? 'No Title';
          final pollDescription = pollData['description'] ?? 'No Description';

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(pollTitle),
              subtitle: Text(pollDescription),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editPoll(pollId),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deletePoll(pollId),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<DateTime?> _selectExpiryDate(
      BuildContext context, DateTime? selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    return picked;
  }
}
