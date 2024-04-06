import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

class QuestionListPage extends StatelessWidget {
  final String? pollId;

  const QuestionListPage({Key? key, this.pollId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions for Poll'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .where('poll_id', isEqualTo: pollId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot questionDocument = snapshot.data!.docs[index];
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('options')
                    .where('question_id', isEqualTo: questionDocument.id)
                    .get(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> optionSnapshot) {
                  if (optionSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (optionSnapshot.hasError) {
                    return Text('Error: ${optionSnapshot.error}');
                  }
                  return ListTile(
                    title: Text(questionDocument['question_txt']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: optionSnapshot.data!.docs
                          .map((DocumentSnapshot optionDocument) {
                        return RadioListTile<String>(
                          title: Text(optionDocument['option_txt']),
                          value: optionDocument.id,
                          groupValue:
                              null, // Điền giá trị của nhóm ở đây nếu bạn muốn sử dụng RadioButton
                          onChanged: (String? value) {
                            // Viết logic của bạn ở đây để xử lý khi người dùng chọn một câu trả lời
                            // Ví dụ: update dữ liệu trong Firebase
                          },
                        );
                      }).toList(),
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
