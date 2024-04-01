import 'package:flutter/material.dart';

class AnswerResultPage extends StatefulWidget {
  const AnswerResultPage({Key? key}) : super(key: key);

  @override
  _AnswerResultPageState createState() => _AnswerResultPageState();
}

class _AnswerResultPageState extends State<AnswerResultPage> {
  List<String> answeredQuestions = [
    'Question 1',
    'Question 2',
    'Question 3',
    'Question 4'
  ];

  String selectedQuestion = 'Question 1'; // Default selected question
  List<String> selectedAnswers = []; // List to store selected answers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Answer Results'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Select a question', // Label for the dropdown button
               
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                      color: Colors.blueAccent), // Border color when enabled
                ),
              ),
              child: DropdownButton<String>(
                value: selectedQuestion,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedQuestion = newValue!;
                  });
                },
                items: answeredQuestions.map((String question) {
                  return DropdownMenuItem<String>(
                    value: question,
                    child: Text(
                      question,
                      style: const TextStyle(
                        color: Colors.blue, // Change text color
                        fontWeight: FontWeight.bold, // Make text bold
                        fontSize: 18.0, // Increase font size
                      ),
                    ),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down), // Change dropdown icon
                iconSize: 30.0, // Increase icon size
                elevation: 16, // Add shadow
                underline: Container(
                  height: 2,
                  color:
                      Colors.transparent, // Set underline color to transparent
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 4, // Replace with actual number of answers
                itemBuilder: (BuildContext context, int index) {
                  String answerText = 'Answer ${index + 1}';
                  bool isSelected = selectedAnswers.contains(answerText);

                  return Card(
                    elevation: 4, // Add shadow to card
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16), // Add margin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Round corners
                      side: BorderSide(
                        color: isSelected
                            ? Colors.blue
                            : Colors
                                .grey, // Change border color based on selection
                        width: 2, // Increase border width
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        answerText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make text bold
                          color: isSelected
                              ? Colors.blue
                              : Colors
                                  .black, // Change text color based on selection
                        ),
                      ),
                      subtitle: Text(
                        'Details of $answerText',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic, // Italicize subtitle
                        ),
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedAnswers.add(answerText);
                            } else {
                              selectedAnswers.remove(answerText);
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
