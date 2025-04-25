import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitTracker(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HabitScreen(),
      ),
    );
  }
}

class HabitScreen extends StatefulWidget {
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final TextEditingController _habitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track your habits for daily and weekly progress!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Habit Add Input
            TextField(
              controller: _habitController,
              decoration: InputDecoration(labelText: 'New Habit'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_habitController.text.isNotEmpty) {
                  Provider.of<HabitTracker>(context, listen: false)
                      .addHabit(_habitController.text);
                  _habitController.clear();
                }
              },
              child: Text('Add Habit'),
            ),
            SizedBox(height: 20),
            Consumer<HabitTracker>(
              builder: (context, habitTracker, child) {
                return Column(
                  children: [
                    // Streak Counter
                    Text(
                      'Streak: ${habitTracker.streak}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Bar Chart
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(show: true),
                          borderData: FlBorderData(show: true),
                          barGroups: habitTracker.getBarGroups(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Habit List with Delete Option
                    Expanded(
                      child: ListView.builder(
                        itemCount: habitTracker.habits.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(habitTracker.habits[index]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                habitTracker.deleteHabit(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HabitTracker extends ChangeNotifier {
  int _streak = 0;
  List<String> _habits = [];
  List<int> _dailyProgress = List.filled(7, 0); // 7 days of the week
  late SharedPreferences _prefs;

  HabitTracker() {
    _loadData();
  }

  List<String> get habits => _habits;
  int get streak => _streak;

  // Load data from SharedPreferences
  void _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    _streak = _prefs.getInt('streak') ?? 0;
    _habits = _prefs.getStringList('habits') ?? [];
    _dailyProgress = _prefs.getStringList('dailyProgress')?.map((e) => int.parse(e)).toList() ?? List.filled(7, 0);
    notifyListeners();
  }

  // Add new habit
  void addHabit(String habitName) {
    _habits.add(habitName);
    _prefs.setStringList('habits', _habits);
    notifyListeners();
  }

  // Delete habit
  void deleteHabit(int index) {
    _habits.removeAt(index);
    _prefs.setStringList('habits', _habits);
    notifyListeners();
  }

  // Mark habit as completed for the day and update streak
  void markHabitAsCompleted() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday - 1; // 0 for Monday, 6 for Sunday

    if (_dailyProgress[dayOfWeek] == 0) {
      _dailyProgress[dayOfWeek] = 1;
      _streak++;
      _prefs.setInt('streak', _streak);
    }

    _prefs.setStringList('dailyProgress', _dailyProgress.map((e) => e.toString()).toList());

    // Check if streak is broken (reset streak if any day is missed)
    if (_dailyProgress.any((progress) => progress == 0)) {
      _streak = 0; // Reset streak if any day is missed in the week
      _prefs.setInt('streak', _streak);
    }

    notifyListeners();
  }

  // Get the Bar Groups for the weekly progress
  List<BarChartGroupData> getBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: _dailyProgress[index].toDouble(),
            colors: [_dailyProgress[index] == 1 ? Colors.green : Colors.grey],
          ),
        ],
      );
    });
  }
}

/*
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.1 # For state management (Check the latest stable version)
  fl_chart: ^0.40.0 # For charting (Check the latest stable version)
  shared_preferences: ^2.0.7 # For local storage of data (Check the latest stable version)

*/ 