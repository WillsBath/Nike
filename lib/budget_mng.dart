import 'package:flutter/material.dart';

void main() {
  runApp(BudgetManagerApp());
}

class BudgetManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BudgetManagerScreen(),
    );
  }
}

class BudgetManagerScreen extends StatefulWidget {
  @override
  _BudgetManagerScreenState createState() => _BudgetManagerScreenState();
}

class _BudgetManagerScreenState extends State<BudgetManagerScreen> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController savingsGoalController = TextEditingController();

  double? availableSavings;
  double? progressPercentage;
  String errorMessage = '';

  // Method to calculate available savings and progress
  void _calculateSavings() {
    setState(() {
      errorMessage = ''; // Clear previous error message

      // Parsing the inputs
      double? income = double.tryParse(incomeController.text);
      double? expenses = double.tryParse(expensesController.text);
      double? savingsGoal = double.tryParse(savingsGoalController.text);

      // Validation checks for invalid inputs
      if (income == null || expenses == null || savingsGoal == null) {
        errorMessage = 'Please enter valid numeric values for all fields.';
        return;
      }
      if (income < 0 || expenses < 0 || savingsGoal < 0) {
        errorMessage = 'Income, expenses, and savings goal cannot be negative.';
        return;
      }

      // Calculating available savings and progress towards the goal
      availableSavings = income - expenses;
      progressPercentage = (availableSavings! / savingsGoal) * 100;
      if (progressPercentage! > 100) {
        progressPercentage = 100; // Cap at 100% if savings exceed goal
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Manager'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Manage Your Budget',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Income Input
              _buildTextField(
                controller: incomeController,
                label: 'Monthly Income',
                hint: 'Enter your income',
                icon: Icons.attach_money,
              ),

              // Expenses Input
              _buildTextField(
                controller: expensesController,
                label: 'Monthly Expenses',
                hint: 'Enter your expenses',
                icon: Icons.credit_card,
              ),

              // Savings Goal Input
              _buildTextField(
                controller: savingsGoalController,
                label: 'Savings Goal',
                hint: 'Enter your savings goal',
                icon: Icons.savings,
              ),

              SizedBox(height: 20),

              // Calculate Button
              ElevatedButton(
                onPressed: _calculateSavings,
                child: Text('Calculate Savings'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  primary: Colors.blue,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),

              // Error Message
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              // Available Savings and Progress Display
              if (availableSavings != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Available Savings: \$${availableSavings!.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Progress Towards Goal: ${progressPercentage!.toStringAsFixed(2)}%',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    // Progress Bar
                    LinearProgressIndicator(
                      value: progressPercentage! / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for Text Fields with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
