import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'ABC Chart';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'ABC Chart',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FieldInputWithTitle('TimeOfDay', 'Roughly what was the time of day?', 'Enter Time of Day'),
          FieldInputWithTitle('Antecedent', 'What triggered the behavior?', 'Enter Antecedent'),
          FieldInputWithTitle('Behavior', 'What exactly did Jack do?', 'Enter Behavior'),
          FieldInputWithTitle('Consequence', 'What happened right after the behavior?', 'Enter Consequence'),
        ],
      ),
    );
  }
}

class FieldInputWithTitle extends StatelessWidget {
  final String title;
  final String smallText;
  final String hintText;

  const FieldInputWithTitle(this.title, this.smallText, this.hintText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            smallText,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
