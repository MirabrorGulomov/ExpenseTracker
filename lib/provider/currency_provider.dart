import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {
  String _selectedCurrency = "UZS";

  String get selectedCurrency => _selectedCurrency;

  void setSelectedCurrency(String newCurrency) {
    _selectedCurrency = newCurrency;
    notifyListeners();
  }
}
