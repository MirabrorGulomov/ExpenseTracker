import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../models/category.dart';
import '../models/expenditures.dart';
import 'package:http/http.dart' as http;

class ExpensesProvider extends ChangeNotifier {
  List<Expenditures> _expenditures = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Expenditures> get expenditures => _expenditures;

  Future<void> removeExpenditure(String id) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }
    final String? idToken = await user.getIdToken();
    print('ID Token for deletion: $idToken');

    // Include the expenditure's ID in the URL
    final url = Uri.https(
      "expense-tracker-ada0e-default-rtdb.firebaseio.com",
      "/expenditures/${user.uid}/$id.json",
    );

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          // Include the token if necessary
          "Authorization": "Bearer $idToken",
        },
      );

      if (response.statusCode == 200) {
        _expenditures.removeWhere((expenditure) => expenditure.id == id);
        notifyListeners();
      } else {
        // Handle the error. Maybe the item was already deleted or the id is wrong.
        print('Error deleting the item: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors here
      print('An error occurred while deleting the item: $error');
    }
  }

  void updateExpenditure(Expenditures updatedExpense) {
    int index = _expenditures
        .indexWhere((expenditure) => expenditure.id == updatedExpense.id);
    if (index != -1) {
      _expenditures[index] = updatedExpense;
      notifyListeners();
    }
  }

  void clearExpenditures() {
    _expenditures.clear();
    notifyListeners();
  }

  Future<void> addExpenditures(Expenditures expenditure) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return;
    final idToken = await user.getIdToken();
    final url = Uri.https("expense-tracker-ada0e-default-rtdb.firebaseio.com",
        "/expenditures/${user.uid}.json", {
      'auth': idToken,
    });
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        },
        body: json.encode(
          {
            "details": expenditure.details,
            "quantity": expenditure.amount,
            "category": expenditure.category.title,
            "date": expenditure.date.toIso8601String(),
          },
        ),
      );

      // Only add the item to the local list if the POST request was successful
      if (response.statusCode == 200) {
        _expenditures.add(expenditure);
        notifyListeners();
      } else {
        print("error");
      }
    } catch (error) {
      print("error + $error");
    }
  }

  Future<void> loadItems() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      final String? idToken = await user.getIdToken(true);
      if (idToken == null) {
        print('ID token is null');
        return;
      }

      // The URL must match your database structure and rules.
      final url = Uri.https("expense-tracker-ada0e-default-rtdb.firebaseio.com",
          "/expenditures/${user.uid}.json", {
        'auth': idToken,
      });

      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        if (response.body == null || response.body.isEmpty) {
          print('No data available at this path');
          _expenditures =
              []; // Set expenditures to an empty list or handle appropriately
          notifyListeners();
          return;
        }
        final Map<String, dynamic> extractedData =
            jsonDecode(response.body) as Map<String, dynamic>;
        final List<Expenditures> loadedExpenditures = [];

        extractedData.forEach((expenseId, expenseData) {
          DateTime parsedDate =
              DateTime.tryParse(expenseData['date']) ?? DateTime.now();

          // Parsing quantity and ensuring it's an integer
          int amount = int.parse(expenseData['quantity'].toString());

          // Handling category
          String categoryTitle = expenseData["category"] ?? 'Unknown';
          Category category = categories.entries
              .firstWhere((catItem) => catItem.value.title == categoryTitle,
                  orElse: () =>
                      categories.entries.first // Default category if not found
                  )
              .value;

          loadedExpenditures.add(
            Expenditures(
              id: expenseId,
              details: expenseData['details'] ?? 'No details',
              amount: amount,
              category: category,
              date: parsedDate,
            ),
          );
        });

        _expenditures = loadedExpenditures;
        notifyListeners();
      } else {
        print(
            'Failed to load expenditures. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print(
          'User is not logged in. No token to use for authenticated requests.');
    }
  }

  Future<void> refreshExpenditures() async {
    try {
      await loadItems();
    } catch (error) {
      // Handle the error appropriately
      print('An error occurred during refresh: $error');
    }
  }

  Map<int, double> getWeeklyExpenses() {
    Map<int, double> weeklyExpenses = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0
    };

    for (var expenditure in _expenditures) {
      int weekDay = expenditure.date.weekday;
      weeklyExpenses[weekDay] = weeklyExpenses[weekDay]! + expenditure.amount;
    }

    return weeklyExpenses;
  }

  double getTotalExpenses() {
    return _expenditures.fold(0, (total, exp) => total + exp.amount);
  }
}
