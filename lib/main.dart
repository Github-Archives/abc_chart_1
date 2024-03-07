import 'package:flutter/material.dart';

import 'dart:async';

// 1. Add the dependencies
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// import the database helper file
import 'sqflite_database_helper.dart';

// void main() => runApp(const MyApp());
// By adding the async keyword, you can now use the await keyword within the main
// function if you have asynchronous operations to perform before running your app.
// Keep in mind that you should use await only if you are calling asynchronous functions
// or operations within the main function. If your main function doesn't involve asynchronous
// operations, adding async won't have any effect.
void main() async {

  // Create a Dog and add it to the dogs table
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await DatabaseHelper.insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await DatabaseHelper.getDogs()); // Prints a list that includes Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await DatabaseHelper.updateDog(fido);

  // Print the updated results.
  print(await DatabaseHelper.getDogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await DatabaseHelper.deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await DatabaseHelper.getDogs());

  // Your existing main function code
  runApp(const MyApp());
}

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
        body: Column(
          children: [
            const SizedBox(height: 1), // Add spacing between form and dog list
            const DogList(),
            const MyCustomForm(),
          ],
        ),
        // body: const DogList(),
        // body: const MyCustomForm(),
      ),
    );
  }
}

// /////////////////////////////////////////////////////////////////////////////
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
    // return Padding(
    return SingleChildScrollView(
      child: Padding(
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
    ),
    );
  }
}

// ////////////////////////////////////////////////////////////
// New
class DogList extends StatefulWidget {
  const DogList({Key? key}) : super(key: key);

  @override
  _DogListState createState() => _DogListState();
}

class _DogListState extends State<DogList> {
  late Future<List<Dog>> _dogs;

  @override
  void initState() {
    super.initState();
    _dogs = DatabaseHelper.getDogs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dog>>(
      future: _dogs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No dogs in the database.');
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final dog = snapshot.data![index];
                return ListTile(
                  title: Text('${dog.name} - Age: ${dog.age}'),
                );
              },
            ),
          );
        }
      },
    );
  }
}