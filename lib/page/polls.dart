import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ẩn nút quay về
        centerTitle: true, // Căn giữa tiêu đề
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white, // Màu chữ
            fontSize: 20.0, // Cỡ chữ
            fontWeight: FontWeight.bold, // Độ đậm
          ),
        ),
        backgroundColor: Colors.blueAccent, // Màu nền
        elevation: 0, // Bỏ bóng đổ
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 48, 173, 100), Colors.blue],
          ),
        ),
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
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children:
                    snapshot.data!.docs.map((DocumentSnapshot pollDocument) {
                  Map<String, dynamic> pollData =
                      pollDocument.data() as Map<String, dynamic>;
                  String? pollId =
                      pollDocument.id; // Assuming poll ID is needed

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
                }).toList(),
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
                builder: (context, AsyncSnapshot<QuerySnapshot> optionSnapshot) {
                  if (optionSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (optionSnapshot.hasError) {
                    return Text('Error: ${optionSnapshot.error}');
                  }
                  return ListTile(
                    title: Text(questionDocument['question_txt']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: optionSnapshot.data!.docs.map((DocumentSnapshot optionDocument) {
                        return RadioListTile<String>(
                          title: Text(optionDocument['option_txt']),
                          value: optionDocument.id,
                          groupValue: null, // Điền giá trị của nhóm ở đây nếu bạn muốn sử dụng RadioButton
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
