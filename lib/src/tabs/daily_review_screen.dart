import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store.dart';

class DailyReviewScreen extends StatefulWidget {
  final VoidCallback updateNotifier;
  const DailyReviewScreen(this.updateNotifier, {Key? key}) : super(key: key);
  @override
  _DailyReviewScreenState createState() => _DailyReviewScreenState();
}

class _DailyReviewScreenState extends State<DailyReviewScreen> {
  List<Map<String, dynamic>> todayExpenses = getTodayExpenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Your Spendings'),
        centerTitle: true,
        // backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: todayExpenses.length,
          itemBuilder: (context, index) {
            final expense = todayExpenses[index];
            if (expense['confirmed'] == false) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(expense['category']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon(expense['category']),
                          size: 30, color: Colors.black54),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense['details'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${expense['amount'].toString()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _editExpense(index),
                            icon: const Icon(Icons.edit, size: 20),
                          ),
                          IconButton(
                            onPressed: () => _deleteExpense(index),
                            icon: const Icon(Icons.delete, size: 20),
                          ),
                          IconButton(
                            onPressed: () => _addExpense(index),
                            icon: const Icon(Icons.done, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(expense['category']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(_getCategoryIcon(expense['category']),
                          size: 30, color: Colors.grey),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense['details'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey, // Grey text
                                decoration: TextDecoration
                                    .lineThrough, // Crossed-out text
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${expense['amount'].toString()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _editExpense(index),
                            icon: const Icon(Icons.edit, size: 20),
                          ),
                          IconButton(
                            onPressed: () => _deleteExpense(index),
                            icon: const Icon(Icons.delete, size: 20),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.done, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAll(),
        child: const Icon(Icons.done_all),
        backgroundColor: Colors.blueAccent.withOpacity(0.5),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Transportation':
        return Colors.greenAccent.withOpacity(0.1);
      case 'Dining':
        return Colors.orangeAccent.withOpacity(0.1);
      case 'Grocery':
        return Colors.yellowAccent.withOpacity(0.1);
      default:
        return Colors.greenAccent.withOpacity(0.1);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Transportation':
        return Icons.directions_bus;
      case 'Dining':
        return Icons.restaurant;
      case 'Grocery':
        return Icons.shopping_cart;
      default:
        return Icons.category;
    }
  }

  void _editExpense(int index) async {
    final expense = recentExpenses[index];
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        String category = expense['category'];
        String details = expense['details'];
        String amount = expense['amount'].toString();
        return AlertDialog(
          title: const Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: details),
                decoration: const InputDecoration(labelText: 'Details'),
                onChanged: (value) {
                  details = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: amount),
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'category': category,
                  'details': details,
                  'amount': double.tryParse(amount) ?? 0,
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        recentExpenses[index] = result;
      });
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      recentExpenses.removeAt(index);
    });
  }

  void _addExpense(index) {
    // Implement add expense logic here
    confirmExpense(index);
    setState(() {
      todayExpenses = getTodayExpenses();
    });
  }

  void _addAll() {
    // Implement add expense logic here
    confirmAllExpense();
    setState(() {
      todayExpenses = getTodayExpenses();
    });
    widget.updateNotifier();
  }
}
