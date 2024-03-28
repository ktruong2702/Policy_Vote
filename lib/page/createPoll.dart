import 'package:flutter/material.dart';

class CreatePollPage extends StatefulWidget {
  const CreatePollPage({Key? key}) : super(key: key);

  @override
  _CreatePollPageState createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {
  int? correctAnswerIndex;

  List<String> options = ['', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Xử lý sự kiện khi người dùng nhấn nút back
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             const Text(
              'Create Poll',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Question', // Nhập nội dung câu hỏi
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < options.length; i++)
              ListTile(
                title: TextField(
                  onChanged: (value) => options[i] = value,
                  decoration: InputDecoration(
                    labelText: 'Option ${i + 1}',
                  ),
                ),
                leading: Radio(
                  value: i,
                  groupValue: correctAnswerIndex,
                  onChanged: (int? value) {
                    setState(() {
                      correctAnswerIndex = value;
                    });
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
             
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }


}
