import 'package:bai3/model/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class HomePage extends StatefulWidget {
  final MyUser user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAllQuestions = false;

  Future<bool> hasUserVoted(MyUser user, String pollId) async {
    try {
      final userAnswers = await FirebaseFirestore.instance
          .collection('user_answers')
          .where('user_id', isEqualTo: user.uid)
          .where('poll_id', isEqualTo: pollId)
          .get();

      // Kiểm tra xem có bản ghi phản hồi từ cơ sở dữ liệu hay không
      return userAnswers.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user vote: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const userId = 'user_id'; // Thay đổi bằng user id thực tế
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
        backgroundColor: const Color.fromARGB(230, 68, 71, 245),
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
              List<QueryDocumentSnapshot> allQuestions =
                  snapshot.data!.docs; // All available polls
              List<QueryDocumentSnapshot> visibleQuestions = showAllQuestions
                  ? allQuestions
                  : allQuestions.take(10).toList();

              // Hiển thị danh sách
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  ...visibleQuestions.map((DocumentSnapshot pollDocument) {
                    Map<String, dynamic> pollData =
                        pollDocument.data() as Map<String, dynamic>;
                    String? pollId = pollDocument.id;
                    final expiredTime = pollData['expired_time'];
                    if (expiredTime != null && expiredTime is Timestamp) {
                      final now = Timestamp.now();
                      if (now.compareTo(expiredTime) >= 0) {
                        // Bỏ qua bài khảo sát đã hết hạn
                        return const SizedBox.shrink();
                      }
                    }
                    return GestureDetector(
                      onTap: () async {
                        final hasVoted =
                            await hasUserVoted(widget.user, pollId);
                        if (hasVoted) {
                          // Hiển thị thông báo rằng người dùng đã bỏ phiếu cho cuộc khảo sát này rồi
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Voted'),
                              content: const Text('You have already voted this poll'),


                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionListPage(pollId: pollId),
                            ),
                          );
                        }
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          key: UniqueKey(), // Thêm key vào ListTile
                          title: Text(
                            pollData['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Loại bỏ màu đỏ nếu có khóa
                            ),
                          ),
                          subtitle: Text(
                            pollData['description'],
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (allQuestions.length > 5 &&
                      !showAllQuestions) // Show the "Show All" button only if there are more than 5 polls and showAllQuestions is false
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllQuestions = true;
                        });
                      },
                      child: const Text('Show All Polls'),
                    ),
                  if (showAllQuestions) // Show the "Show Less" button if showAllQuestions is true
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllQuestions = false;
                        });
                      },
                      child: const Text('Show Less'),
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
  Map<String, String?> selectedAnswers = {};

  void setSelectedAnswer(String questionId, String? answerId, String? answer) {
    selectedAnswers[questionId] = answerId;
    notifyListeners();
  }

  String? getSelectedAnswerId(String questionId) {
    return selectedAnswers[questionId];
  }

  String? getSelectedAnswer(String questionId) {
    String? answerId = selectedAnswers[questionId];
    if (answerId == 'option_1') {
      return 'Yes';
    } else if (answerId == 'option_2') {
      return 'No';
    } else if (answerId == 'option_3') {
      return 'No Answer';
    }
    return null;
  }

  void removeSelectedAnswer(String questionId) {
    selectedAnswers.remove(questionId);
    notifyListeners();
  }
}

class QuestionListPage extends StatefulWidget {
  final String? pollId;
  final String? userid;

  const QuestionListPage({Key? key, this.pollId, this.userid})
      : super(key: key);

  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  late AsyncSnapshot<QuerySnapshot>
      _snapshot; // Define a variable to store the snapshot

  @override
  Widget build(BuildContext context) {
    final questionState = Provider.of<QuestionState>(context);
    String? pollId;

    return WillPopScope(
      onWillPop: () async {
        // Unchoose all answers when back button is pressed
        _unchooseAll(questionState);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Question List'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('questions')
              .where('poll_id', isEqualTo: widget.pollId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            _snapshot = snapshot; // Store the snapshot
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot questionDocument = snapshot.data!.docs[index];
                String questionId = questionDocument.id;
                String? selectedAnswerId =
                    questionState.getSelectedAnswerId(questionId);
                String? selectedAnswer =
                    questionState.getSelectedAnswer(questionId);

                return Column(
                  children: [
                    ListTile(
                      title: Text(questionDocument['question_txt']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'option_1',
                            groupValue: selectedAnswerId,
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
                                  questionState.setSelectedAnswer(
                                      questionId, value, 'Yes');
                                } else {
                                  questionState
                                      .removeSelectedAnswer(questionId);
                                }
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('No'),
                            value: 'option_2',
                            groupValue: selectedAnswerId,
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
                                  questionState.setSelectedAnswer(
                                      questionId, value, 'No');
                                } else {
                                  questionState
                                      .removeSelectedAnswer(questionId);
                                }
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('No Answer'),
                            value: 'option_3',
                            groupValue: selectedAnswerId,
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
                                  questionState.setSelectedAnswer(
                                      questionId, value, 'No Answer');
                                } else {
                                  questionState
                                      .removeSelectedAnswer(questionId);
                                }
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Reset individual answer
                              _unchooseQuestion(questionState, questionId);
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              onPressed: () {
                bool allQuestionsAnswered =
                    _allQuestionsAnswered(questionState);
                if (!allQuestionsAnswered) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Answers'),
                        content: const Text(
                            'Please answer all questions before submitting.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Save answers to Firebase and reset all answers
                  _saveAndUnchoose(context.read<QuestionState>(), widget.pollId,
                      widget.userid);

                  // Navigate back to HomePage
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.check),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Reset all answers
              _showResetConfirmationDialog(questionState);
            },
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  bool _allQuestionsAnswered(QuestionState questionState) {
    List<DocumentSnapshot> docs = _snapshot.data!.docs;
    for (var doc in docs) {
      String questionId = doc.id;
      String? selectedAnswerId = questionState.getSelectedAnswerId(questionId);
      if (selectedAnswerId == null) {
        return false;
      }
    }
    return true;
  }

  void _showResetConfirmationDialog(QuestionState questionState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Answers'),
          content: const Text(
              'Are you sure you want to reset all selected answers for this poll?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _unchooseAll(questionState);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveAndUnchoose(
      QuestionState questionState, String? pollId, String? userId) {
    // Save answers to Firebase
    _saveAnswersToFirebase(questionState.selectedAnswers, pollId);

    // Reset all answers
    _unchooseAll(questionState);
  }

  void _saveAnswersToFirebase(
      Map<String, String?> selectedAnswers, String? pollId) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Timestamp timestamp = Timestamp.now();

    selectedAnswers.forEach((questionId, answerId) {
      if (answerId != null) {
        String answerTxt = '';

        switch (answerId) {
          case 'option_1':
            answerTxt = 'Yes';
            break;
          case 'option_2':
            answerTxt = 'No';
            break;
          case 'option_3':
            answerTxt = 'No Answer';
            break;
        }

        // Save answer to Firebase
        FirebaseFirestore.instance.collection('user_answers').add({
          'poll_id': pollId,
          'timestamp': timestamp,
          'user_id': userId,
          'answer_id': answerId,
          'answer': answerTxt,
          'question_id': questionId,
        }).then((_) {
          print('Answer saved to Firebase');
        }).catchError((error) {
          print('Failed to save answer: $error');
        });
      }
    });
  }

  void _unchooseAll(QuestionState questionState) {
    // Reset all answers
    questionState.selectedAnswers.clear();
    setState(() {});
  }

  void _unchooseQuestion(QuestionState questionState, String questionId) {
    // Reset individual answer
    questionState.removeSelectedAnswer(questionId);
    setState(() {});
  }

  void _lockPoll(String? pollId, String? userId, QuestionState questionState) {
    FirebaseFirestore.instance
        .collection('user_answers')
        .where('poll_id', isEqualTo: pollId)
        .where('user_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        // Nếu người dùng đã vote cho poll này rồi, hiển thị thông báo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Already Voted'),
              content: const Text('You have already voted in this poll.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _saveAnswersToFirebase(questionState.selectedAnswers, pollId);
      }
    }).catchError((error) {
      print('Error checking user vote: $error');
    });
  }
}
