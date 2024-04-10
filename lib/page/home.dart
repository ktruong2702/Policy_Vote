import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PollAnswerResult extends StatelessWidget {
  final String userId;

  const PollAnswerResult({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Answered Polls',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 101, 83, 182),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_answers')
            .where('user_id', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<QueryDocumentSnapshot> answeredPolls = snapshot.data!.docs;

          if (answeredPolls.isEmpty) {
            return Center(
              child: Text('You have not answered any polls yet.'),
            );
          }

          // Tạo một danh sách để nhóm các cuộc thăm dò theo poll_id
          Map<String, List<Map<String, dynamic>>> groupedPolls = {};

          // Nhóm các cuộc thăm dò theo poll_id
          answeredPolls.forEach((answeredPoll) {
            var pollId = answeredPoll['poll_id'];
            var questionId = answeredPoll['question_id'];
            var selectedAnswer = answeredPoll['answer'];

            if (!groupedPolls.containsKey(pollId)) {
              groupedPolls[pollId] = [];
            }

            groupedPolls[pollId]!.add({
              'questionId': questionId,
              'selectedAnswer': selectedAnswer,
            });
          });

          return ListView.builder(
            itemCount: groupedPolls.length,
            itemBuilder: (context, index) {
              var pollId = groupedPolls.keys.elementAt(index);
              var answers = groupedPolls[pollId]!;

              return FutureBuilder(
                future: _getPollTitle(pollId),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  var pollTitle = snapshot.data!;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Poll Title: $pollTitle',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: answers.map((answer) {
                            return FutureBuilder(
                              future: _getQuestionText(answer['questionId']),
                              builder:
                                  (context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                var questionText = snapshot.data!;
                                var selectedAnswer = answer['selectedAnswer'];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Question: $questionText',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text('Selected Answer: $selectedAnswer'),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Hàm để lấy tiêu đề của cuộc thăm dò từ Firestore
Future<String> _getPollTitle(String pollId) async {
  var pollQuery =
      await FirebaseFirestore.instance.collection('polls').doc(pollId).get();
  return pollQuery['title'];
}

// Hàm để lấy nội dung của câu hỏi từ Firestore
Future<String> _getQuestionText(String questionId) async {
  var questionQuery = await FirebaseFirestore.instance
      .collection('questions')
      .doc(questionId)
      .get();
  return questionQuery['question_txt'];
}
