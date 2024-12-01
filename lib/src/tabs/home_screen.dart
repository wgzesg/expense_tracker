import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Dummy data for categories and expenses
  final Map<String, double> categorySummary = {
    'Food': 120.0,
    'Transportation': 50.0,
    'Entertainment': 80.0,
    'Others': 40.0,
  };

  final List<Map<String, dynamic>> recentExpenses = [
    {'category': 'Food', 'amount': 12.0, 'date': 'Today, 9:30 AM'},
    {'category': 'Transport', 'amount': 20.0, 'date': 'Today, 8:00 AM'},
    {'category': 'Entertainment', 'amount': 50.0, 'date': 'Yesterday'},
  ];

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
                childAspectRatio:
                    2.5, // Adjust the aspect ratio to control item dimensions
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Space between items
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow for long text
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
                // Add action for the button
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
                  title: Text(expense['category']),
                  subtitle: Text(expense['date']),
                  trailing: Text(
                    '\$${expense['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),

            // 4. More button
            TextButton(
              onPressed: () {
                // Add action to extend or show more expenses
              },
              child: const Text(
                'More',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
