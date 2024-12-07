import 'package:flutter/material.dart';

List<Map<String, dynamic>> todayExpenses = [
  {
    'category': 'Transportation',
    'details': 'Taxi ride home',
    'amount': 23.5,
    'date': 'Today',
    'confirmed': false,
  },
  {
    'category': 'Dining',
    'details': 'Lunch with Friends',
    'amount': 30.0,
    'date': 'Today',
    'confirmed': false,
  },
  {
    'category': 'Dining',
    'details': 'Dinner with Friends',
    'amount': 20.0,
    'date': 'Today',
    'confirmed': false,
  },
  {
    'category': 'Grocery',
    'details': 'breakfast next week',
    'amount': 40.0,
    'date': 'Today',
    'confirmed': false,
  },
];

List<Map<String, dynamic>> recentExpenses = [
  {
    'category': 'Dining',
    'details': 'family outing',
    'amount': 12.0,
    'date': 'Today, 9:30 AM'
  },
  {
    'category': 'Transportation',
    'details': 'taxi to work',
    'amount': 20.0,
    'date': 'Today, 8:00 AM'
  },
  {
    'category': 'Grocery',
    'details': 'fruits',
    'amount': 50.0,
    'date': 'Yesterday'
  },
];

List<Map<String, dynamic>> getExpenses() {
  return recentExpenses;
}

List<Map<String, dynamic>> getTodayExpenses() {
  return todayExpenses;
}

void confirmExpense(int index) {
  if (todayExpenses[index]['confirmed']) {
    return;
  }
  todayExpenses[index]['confirmed'] = true;
  recentExpenses.add(todayExpenses[index]);
}

void confirmAllExpense() {
  for (int i = 0; i < todayExpenses.length; i++) {
    confirmExpense(i);
  }
}
