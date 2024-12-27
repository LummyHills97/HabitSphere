import 'package:isar/isar.dart';

// Run this command to generate the file: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // Habit ID
  Id id = Isar.autoIncrement;

  // Habit name
  late String name;

  // Completed days
  List<DateTime> completedDays = [

     // DateTime(year, month, day),
  // DateTime(2024, 1, 1),
  // DateTime(2024, 1, 2),
  ];

}

