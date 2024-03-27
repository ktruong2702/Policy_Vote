import 'package:flutter/material.dart';
import 'package:bai3/page/recentPoll.dart';
import 'package:bai3/page/createPoll.dart';
class PollPage extends StatefulWidget {
  const PollPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizSelectionPageState createState() => _QuizSelectionPageState();
}

class _QuizSelectionPageState extends State<PollPage> {
  String? selectedQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Home'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            floating:
                true, // Đặt floating thành true để SliverAppBar có thể đặt cố định khi cuộn
            pinned:
                true, // Đặt pinned thành true để SliverAppBar luôn hiển thị khi cuộn lên đầu
            backgroundColor: Colors.blue,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 20.0),
                  // Nội dung của bạn ở đây
                  Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: const FlutterLogo(size: 60.0),
                      title: Text(
                        'Poll 1',
                        style: TextStyle(
                          color: selectedQuestion == 'Question 1'
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedQuestion = 'Question 1';
                        });
                      },
                      selected: selectedQuestion == 'Question 1',
                      subtitle: const Text(
                        'A sufficiently long subtitle warrants three lines.',
                      ),
                      trailing: const Icon(Icons.more_vert),
                      isThreeLine: true,
                      tileColor: const Color.fromARGB(255, 252, 251, 251),
                      textColor: const Color.fromARGB(236, 0, 0, 0),
                    ),
                  ),
                          const SizedBox(height: 10,),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: const FlutterLogo(size: 60.0),
                      title: Text(
                        'Poll 2',
                        style: TextStyle(
                          color: selectedQuestion == 'Question 2'
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedQuestion = 'Question 2';
                        });
                      },
                      selected: selectedQuestion == 'Question 2',
                      subtitle: const Text(
                        'A sufficiently long subtitle warrants three lines.',
                      ),
                      trailing: const Icon(Icons.more_vert),
                      isThreeLine: true,
                      tileColor: const Color.fromARGB(255, 252, 251, 251),
                      textColor: const Color.fromARGB(236, 0, 0, 0),
                    ),
                  ),
                  // Thêm nút chuyển hướng đến trang RecentPollsPage
                    const SizedBox(height: 16,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecentPollPage(),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),

                     // Thêm nút tạo câu hỏi
                  const SizedBox(height: 16,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePollPage(),
                        ),
                      );
                    },
                    child: const Text('Create Question'),
                  ),
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
                  builder: (context) => QuizPage(selectedQuestion!)),
            );
          } else {
            // Hiển thị thông báo nếu người dùng chưa chọn câu hỏi
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please choose a poll to vote'),
            ));
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  final String selectedQuestion;

  const QuizPage(this.selectedQuestion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedQuestion),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bạn đã chọn câu hỏi: $selectedQuestion'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Bắt đầu làm bài thi với câu hỏi đã chọn
              },
              child: const Text('Vote'),
            ),
          ],
        ),
      ),
    );
  }
}



