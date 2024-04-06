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
            stream: PollService().getPolls(),
            builder: (context, AsyncSnapshot<List<Poll>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              List<Poll> polls = snapshot.data!;

              List<Poll> visiblePolls =
                  showAllQuestions ? polls : polls.take(5).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: visiblePolls.length + (showLimitedQuestions ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == visiblePolls.length && showLimitedQuestions) {
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          showAllQuestions = true;
                          showLimitedQuestions = false;
                        });
                      },
                      child: Text('See All'),
                    );
                  } else {
                    Poll poll = visiblePolls[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          poll.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          poll.description,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionListPage(pollId: poll.id),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class QuestionListPage extends StatefulWidget {
  final String? pollId;
  const QuestionListPage({Key? key, this.pollId}) : super(key: key);

  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  Map<String, String> _userAnswers = {};

  void _handleAnswerSelected(String questionId, String answerId) {
    setState(() {
      _userAnswers[questionId] = answerId;
    });
    UserAnswerService().saveUserAnswer(questionId, answerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions for Poll'),
      ),
      body: FutureBuilder(
        future: QuestionService().getQuestionsForPoll(widget.pollId!),
        builder: (context, AsyncSnapshot<List<Question>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<Question> questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              Question question = questions[index];
              return FutureBuilder(
                future: OptionService().getOptionsForQuestion(question.id),
                builder: (context, AsyncSnapshot<List<Option>> optionSnapshot) {
                  if (optionSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (optionSnapshot.hasError) {
                    return Text('Error: ${optionSnapshot.error}');
                  }
                  List<Option> options = optionSnapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(question.text),
                      ),
                      FutureBuilder(
                        future: AnswerService().getAnswersForQuestion(question.id),
                        builder: (context, AsyncSnapshot<List<Answer>> answerSnapshot) {
                          if (answerSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (answerSnapshot.hasError) {
                            return Text('Error: ${answerSnapshot.error}');
                          }
                          List<Answer> answers = answerSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: answers.map((answer) {
                              return RadioListTile<String>(
                                title: Text(answer.text),
                                value: answer.id,
                                groupValue: _userAnswers[question.id],
                                onChanged: (String? value) {
                                  _handleAnswerSelected(question.id, answer.id);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
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

/// Service class for saving user answers to questions in Firestore.
///
/// This class provides a method to save user answers to the 'user_answers'
/// collection in Firestore. It encapsulates the Firestore-specific logic
/// and allows other parts of the application to easily save user answers.
///
/// Usage:
///   1. Create an instance of `UserAnswerService`.
///   2. Call the `saveUserAnswer` method with the `questionId` and `answerId`
///      whenever a user selects an answer to a question.
///
/// Example:
///   final userAnswerService = UserAnswerService();
///   userAnswerService.saveUserAnswer('question1', 'answer2');
class UserAnswerService {
  final CollectionReference _userAnswersCollection =
      FirebaseFirestore.instance.collection('user_answers');

      /// Saves a user's answer to a question in Firestore.
  ///
  /// [questionId] is the ID of the question.
  /// [answerId] is the ID of the selected answer.
  ///
  /// Returns a [Future] that completes when the answer is saved.
  Future<void> saveUserAnswer(String questionId, String answerId) async {
    await _userAnswersCollection.doc().set({
      'question_id': questionId,
      'answer_id': answerId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

/// Service class for retrieving polls from Firestore.
///
/// This class provides a method to retrieve a stream of polls from the 'polls'
/// collection in Firestore. It encapsulates the Firestore-specific logic
/// and allows other parts of the application to easily access the polls data.
///
/// Usage:
///   1. Create an instance of `PollService`.
///   2. Call the `getPolls` method to retrieve a stream of polls.
///   3. Listen to the stream and handle the emitted list of `Poll` objects.
///
/// Example:
///   final pollService = PollService();
///   final pollStream = pollService.getPolls();
///   pollStream.listen((polls) {
///     // Handle the list of polls
///   });
class PollService {
  final CollectionReference _pollsCollection =
      FirebaseFirestore.instance.collection('polls');

 /// Retrieves a stream of polls from Firestore.
  ///
  /// The polls are ordered by the 'title' field in ascending order.
  ///
  /// Returns a [Stream] that emits a list of [Poll] objects.
  Stream<List<Poll>> getPolls() {
    return _pollsCollection.orderBy('title').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Poll.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList());

  }
}

/// Service class for retrieving questions for a specific poll from Firestore.
///
/// This class provides a method to retrieve a list of questions associated with
/// a specific poll ID from the 'questions' collection in Firestore.
class QuestionService {
  final CollectionReference _questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  /// Retrieves a list of questions for a specific poll ID from Firestore.
  ///
  /// [pollId] is the ID of the poll.
  ///
  /// Returns a [Future] that completes with a list of [Question] objects.
  Future<List<Question>> getQuestionsForPoll(String pollId) async {
    QuerySnapshot snapshot = await _questionsCollection
        .where('poll_id', isEqualTo: pollId)
        .get();
    return snapshot.docs.map((doc) => Question.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}

/// Service class for retrieving options for a specific question from Firestore.
///
/// This class provides a method to retrieve a list of options associated with
/// a specific question ID from the 'options' collection in Firestore.
class OptionService {
  final CollectionReference _optionsCollection =
      FirebaseFirestore.instance.collection('options');

  /// Retrieves a list of options for a specific question ID from Firestore.
  ///
  /// [questionId] is the ID of the question.
  ///
  /// Returns a [Future] that completes with a list of [Option] objects.
  Future<List<Option>> getOptionsForQuestion(String questionId) async {
    QuerySnapshot snapshot = await _optionsCollection
        .where('question_id', isEqualTo: questionId)
        .get();
    return snapshot.docs.map((doc) => Option.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}

/// Service class for retrieving answers for a specific question from Firestore.
///
/// This class provides a method to retrieve a list of answers associated with
/// a specific question ID from the 'answers' collection in Firestore.
class AnswerService {
  final CollectionReference _answersCollection =
      FirebaseFirestore.instance.collection('answers');

  /// Retrieves a list of answers for a specific question ID from Firestore.
  ///
  /// [questionId] is the ID of the question.
  ///
  /// Returns a [Future] that completes with a list of [Answer] objects.
  Future<List<Answer>> getAnswersForQuestion(String questionId) async {
    QuerySnapshot snapshot = await _answersCollection
        .where('question_id', isEqualTo: questionId)
        .get();
    return snapshot.docs.map((doc) => Answer.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}

/// Represents a poll.
class Poll {
  final String id;
  final String title;
  final String description;

  Poll({required this.id, required this.title, required this.description});

  /// Creates a [Poll] object from a JSON map and an ID.
  ///
  /// [json] is the JSON map containing the poll data.
  /// [id] is the ID of the poll.
  ///
  /// Returns a new [Poll] object.
  factory Poll.fromJson(Map<String, dynamic> json, String id) {
    return Poll(
      id: id,
      title: json['title'],
      description: json['description'],
    );
  }
}

/// Represents a question.
class Question {
  final String id;
  final String text;

  Question({required this.id, required this.text});

  /// Creates a [Question] object from a JSON map and an ID.
  ///
  /// [json] is the JSON map containing the question data.
  /// [id] is the ID of the question.
  ///
  /// Returns a new [Question] object.
  factory Question.fromJson(Map<String, dynamic> json, String id) {
    return Question(
      id: id,
      text: json['question_txt'],
    );
  }
}

/// Represents an option for a question.
class Option {
  final String id;
  final String text;

  Option({required this.id, required this.text});

  /// Creates an [Option] object from a JSON map and an ID.
  ///
  /// [json] is the JSON map containing the option data.
  /// [id] is the ID of the option.
  ///
  /// Returns a new [Option] object.
  factory Option.fromJson(Map<String, dynamic> json, String id) {
    return Option(
      id: id,
      text: json['option_txt'],
    );
  }
}

/// Represents an answer to a question.
class Answer {
  final String id;
  final String text;

  Answer({required this.id, required this.text});

  /// Creates an [Answer] object from a JSON map and an ID.
  ///
  /// [json] is the JSON map containing the answer data.
  /// [id] is the ID of the answer.
  ///
  /// Returns a new [Answer] object.
  factory Answer.fromJson(Map<String, dynamic> json, String id) {
    return Answer(
      id: id,
      text: json['answer_txt'],
    );
  }
}