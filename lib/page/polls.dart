import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAllQuestions = false;
  bool showLimitedQuestions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Polls',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(230, 68, 71, 245),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('polls')
                .orderBy('title')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              List<QueryDocumentSnapshot> visibleQuestions =
                  showAllQuestions ? documents : documents.take(5).toList();

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  ...visibleQuestions.map((DocumentSnapshot pollDocument) {
                    Map<String, dynamic> pollData =
                        pollDocument.data() as Map<String, dynamic>;
                    String? pollId = pollDocument.id;

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          pollData['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          pollData['description'],
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionListPage(pollId: pollId),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  if (!showAllQuestions &&
                      documents.length > 5 &&
                      showLimitedQuestions)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllQuestions = true;
                          showLimitedQuestions = false;
                        });
                      },
                      child: Text('See All'),
                    ),
                  if (showAllQuestions)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllQuestions = false;
                          showLimitedQuestions = true;
                        });
                      },
                      child: Text('Show Less'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class QuestionState extends ChangeNotifier {
  Map<String, String?> selectedAnswers =
      {}; // Store selected answers for each question

  void setSelectedAnswer(String questionId, String? answer) {
    selectedAnswers[questionId] =
        answer; // Update selected answer for the question
    // Do not notify listeners here
  }

  String? getSelectedAnswer(String questionId) {
    return selectedAnswers[
        questionId]; // Retrieve selected answer for the question
  }

  void clearSelectedAnswers() {
    selectedAnswers.clear(); // Clear all selected answers
    notifyListeners(); // Notify listeners after clearing
  }
}

class QuestionListPage extends StatefulWidget {
  final String? pollId;

  const QuestionListPage({Key? key, this.pollId}) : super(key: key);

  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  @override
  Widget build(BuildContext context) {
    final questionState = Provider.of<QuestionState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions for Poll'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .where('poll_id', isEqualTo: widget.pollId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data!.docs.isEmpty) {
            // Không có câu hỏi nào, hiển thị nút "Vote"
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  if (questionState.selectedAnswers.isNotEmpty) {
                    // Store selected answers when the button is pressed
                    saveAnswerToFirebase(
                        questionState.selectedAnswers as String?, widget.pollId);
                    // Clear selected answers after storing
                    questionState.clearSelectedAnswers();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Please select an answer'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Vote'),
              ),
            );
          } else {
            // Có câu hỏi được tải lên, hiển thị danh sách câu hỏi
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot questionDocument = snapshot.data!.docs[index];
                String questionId = questionDocument.id;

                return ListTile(
                  title: Text(questionDocument['question_txt']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Text('Yes'),
                        value: 'yes',
                        groupValue: questionState.getSelectedAnswer(questionId),
                        onChanged: (String? value) {
                          questionState.setSelectedAnswer(questionId, value);
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('No'),
                        value: 'no',
                        groupValue: questionState.getSelectedAnswer(questionId),
                        onChanged: (String? value) {
                          questionState.setSelectedAnswer(questionId, value);
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('No Answer'),
                        value: 'no_answer',
                        groupValue: questionState.getSelectedAnswer(questionId),
                        onChanged: (String? value) {
                          questionState.setSelectedAnswer(questionId, value);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void saveAnswerToFirebase(String? answer, String? pollId) {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Thực hiện lưu câu trả lời vào Firebase
  FirebaseFirestore.instance.collection('user_answers').add({
    'poll_id': pollId,
    'timestamp': Timestamp.now(),
    'user_id': userId,
    'answer': answer,
  }).then((_) {
    print('Answer saved to Firebase');
  }).catchError((error) {
    print('Failed to save answer: $error');
  });
}
