import 'package:flutter/material.dart';

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
