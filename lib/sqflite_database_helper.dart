import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }


  static Future<void> insertDog(Dog dog) async {
    final db = await initializeDatabase();
    final result = await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Insert result: $result');
  }


  static Future<List<Dog>> getDogs() async {
    final db = await initializeDatabase();
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');
    print('Dogs from database: $dogMaps');

    return [
      for (final {
      'id': id as int,
      'name': name as String,
      'age': age as int,
      } in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }


  static Future<void> updateDog(Dog dog) async {
    final db = await initializeDatabase();
    await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  static Future<void> deleteDog(int id) async {
    final db = await initializeDatabase();
    await db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

// Example usage in the same file
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
}
