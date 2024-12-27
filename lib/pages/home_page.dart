import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controller
  final TextEditingController textController = TextEditingController();

  // Create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create a New Habit"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter habit name"),
        ),
        actions: [
          // Save button
          TextButton(
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Check habit on & off
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // Edit habit box
  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Habit"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Update habit name"),
        ),
        actions: [
          // Save button
          TextButton(
            onPressed: () {
              String updatedHabitName = textController.text;
              context.read<HabitDatabase>().updateHabitName(habit.id, updatedHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Habit"),
        content: Text("Are you sure you want to delete '${habit.name}'?"),
        actions: [
          // Delete button
          TextButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          // HEATMAP
          _buildHeatMap(),

          // HABITLIST
          _buildHabitList(),
        ],
      ),
    );
  }

  // Build heat map
  Widget _buildHeatMap() {
    // Build database
    final habitDatabase = context.watch<HabitDatabase>(); // Fixed variable name

    // Current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(), // Use the corrected variable name
      builder: (context, snapshot) {
        // Once the data is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        }

        // Handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // Build habit list
  Widget _buildHabitList() {
    // Habit database
    final habitDatabase = context.watch<HabitDatabase>(); // Fixed variable name

    // Current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // Get each individual habit
        final habit = currentHabits[index];
        // Check if the habit is completed today
        bool isCompleteToday = isHabitCompletedToday(habit.completedDays);

        // Return habit tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompleteToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
