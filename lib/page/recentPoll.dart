import 'package:flutter/material.dart';

class RecentPollPage extends StatefulWidget {
  const RecentPollPage({Key? key}) : super(key: key);

  @override
  _RecentPollPage createState() => _RecentPollPage();
}

class _RecentPollPage extends State<RecentPollPage> {
  String? selectedQuestion;
  bool showAllQuestions =
      false; // Biến để kiểm soát việc hiển thị tất cả các câu hỏi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Recent Poll'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Xử lý sự kiện khi người dùng nhấn nút back
                Navigator.pop(context);
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Danh sách các câu hỏi
                  if (!showAllQuestions)
                    Column(
                      children: [
                        buildPollCard('Poll 1'),
                            const SizedBox(height: 10,),
                        buildPollCard('Poll 2'),
                        // Thêm các câu hỏi khác ở đây nếu cần
                      ],
                    ),

                      const SizedBox(height: 16,),
                  if (!showAllQuestions)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showAllQuestions =
                              true; // Khi nhấn nút, hiển thị tất cả các câu hỏi
                        });
                          
                      },
                      child: const Text('See All'),
                    ),
                  // Hiển thị tất cả các câu hỏi
                  if (showAllQuestions) buildPollCard('Poll 1'),
                  if (showAllQuestions) buildPollCard('Poll 2'),
                  // Thêm các câu hỏi khác ở đây nếu cần
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedQuestion != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(selectedQuestion!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please choose a poll to vote'),
              ),
            );
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  // Hàm tạo Card cho câu hỏi
  Widget buildPollCard(String pollName) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: const FlutterLogo(size: 72.0),
        title: Text(
          pollName,
          style: TextStyle(
            color: selectedQuestion == pollName ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          setState(() {
            selectedQuestion = pollName;
          });
        },
        selected: selectedQuestion == pollName,
        subtitle: const Text(
          'A sufficiently long subtitle warrants three lines.',
        ),
        trailing: const Icon(Icons.more_vert),
        isThreeLine: true,
        tileColor: const Color.fromARGB(255, 252, 251, 251),
        textColor: const Color.fromARGB(236, 0, 0, 0),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String selectedQuestion;

  const QuizPage(this.selectedQuestion, {Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedQuestion),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You choose the question is: ${widget.selectedQuestion}'),
            const SizedBox(height: 20),
            Column(
              children: _buildOptions(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Bắt đầu làm bài thi với câu hỏi đã chọn và các câu trả lời được chọn
              },
              child: const Text('Vote'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptions() {
    return [
      for (int i = 0; i < 4; i++)
        CheckboxListTile(
          title: Text('The answer ${i + 1}'),
          value: _selectedOptions.contains('The answer ${i + 1}'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                _selectedOptions.add('The answer ${i + 1}');
              } else {
                _selectedOptions.remove('The answer ${i + 1}');
              }
            });
          },
        ),
    ];
  }
}
