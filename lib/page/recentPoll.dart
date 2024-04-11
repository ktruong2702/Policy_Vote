import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RecentPollPage extends StatefulWidget {
  const RecentPollPage({Key? key}) : super(key: key);

  @override
  _RecentPollPageState createState() => _RecentPollPageState();
}

class _RecentPollPageState extends State<RecentPollPage> {
  late Stream<QuerySnapshot> _pollStream;
  bool _showAllPolls = false;

  @override
  void initState() {
    super.initState();
    _pollStream = FirebaseFirestore.instance
        .collection('polls')
        .where('expired_time', isLessThan: Timestamp.now())
        .orderBy('expired_time', descending: true) // Sort by expired time descending
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Recent Polls',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSerif'
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 83, 182),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: StreamBuilder(
            stream: _pollStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No expired polls available'),
                );
              }
              final documents = snapshot.data!.docs;
              final visiblePolls = _showAllPolls ? documents : documents.take(5).toList();

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  ...visiblePolls.map((DocumentSnapshot pollDocument) {
                    Map<String, dynamic> pollData = pollDocument.data() as Map<String, dynamic>;
                    String pollName = pollData['title'];
                    String description = pollData['description'];
                    Timestamp expiredTime = pollData['expired_time'];

                    return buildPollCard(pollName, description, expiredTime);
                  }),
                  if (!_showAllPolls && documents.length > 5)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllPolls = true;
                        });
                      },
                      child: const Text('See All'),
                    ),
                  if (_showAllPolls)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllPolls = false;
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

  Widget buildPollCard(String pollName, String description, Timestamp expiredTime) {
    DateFormat dateFormat = DateFormat("MM-dd-yyyy, HH:mm a");
    String formattedExpiredTime = dateFormat.format(expiredTime.toDate());
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          pollName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat-Black'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(fontStyle: FontStyle.italic, fontFamily: 'Montserrat-Black', color: Color.fromARGB(204, 0, 0, 0)),
            ),
            Text(
              'Expired: $formattedExpiredTime',
              style: const TextStyle(fontStyle: FontStyle.italic, fontFamily: 'Montserrat-Black', color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
