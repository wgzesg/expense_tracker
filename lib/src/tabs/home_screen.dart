import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/tabs/daily_review_screen.dart';
import 'package:flutter_application_1/store/store.dart';

class HomeScreen extends StatelessWidget {
  // Dummy data for categories and expenses
  final Map<String, double> categorySummary = {
    'Dining': 120.0,
    'Transportation': 50.0,
    'Grocery': 80.0,
    'Others': 40.0,
  };

  List<Map<String, dynamic>> recentExpenses = getExpenses();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Summary Section
            const Text(
              'Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categorySummary.keys.length,
              itemBuilder: (context, index) {
                final category = categorySummary.keys.elementAt(index);
                final amount = categorySummary[category]!;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 2. Button for reviewing today's expenses
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DailyReviewScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Review today’s expenses now'),
            ),

            const SizedBox(height: 24),

            // 3. List of most recent expenses
            const Text(
              'Recent Expenses',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentExpenses.length,
              itemBuilder: (context, index) {
                final expense = recentExpenses[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(expense['details']),
                  subtitle: Text(expense['date']),
                  trailing: Text(
                    '\$${expense['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                );
              },
            ),

            // 4. More button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
              child: const Text(
                'Settings',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for settings
  bool alertsEnabled = true;
  Map<String, double> categoryThresholds = {
    'Food': 100.0,
    'Transportation': 50.0,
    'Entertainment': 75.0,
  };
  double monthlyLimit = 500.0;
  String notificationFrequency = 'Daily'; // Options: 'Daily', 'Weekly'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle alerts
            SwitchListTile(
              title: const Text('Enable Spending Alerts'),
              value: alertsEnabled,
              onChanged: (value) {
                setState(() {
                  alertsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Monthly spending limit
            ListTile(
              title: const Text('Monthly Spending Limit'),
              subtitle: Text('\$${monthlyLimit.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editLimit(context, 'Monthly Limit', monthlyLimit,
                      (newLimit) {
                    setState(() {
                      monthlyLimit = newLimit;
                    });
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Per-category thresholds
            const Text(
              'Category Thresholds',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...categoryThresholds.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text('\$${entry.value.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editLimit(context, '${entry.key} Limit', entry.value,
                        (newLimit) {
                      setState(() {
                        categoryThresholds[entry.key] = newLimit;
                      });
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 16),

            // Notification frequency
            ListTile(
              title: const Text('Notification Frequency'),
              subtitle: Text(notificationFrequency),
              trailing: DropdownButton<String>(
                value: notificationFrequency,
                items: ['Daily', 'Weekly']
                    .map((frequency) => DropdownMenuItem(
                          value: frequency,
                          child: Text(frequency),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    notificationFrequency = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editLimit(
    BuildContext context,
    String title,
    double currentValue,
    void Function(double) onSave,
  ) {
    TextEditingController controller =
        TextEditingController(text: currentValue.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter new limit',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              double? newValue = double.tryParse(controller.text);
              if (newValue != null) {
                onSave(newValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
