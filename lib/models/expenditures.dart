import 'package:expense_tracker_app/models/category.dart';

class Expenditures {
  final String id;
  final String details;
  final int amount;
  final Category category;
  final DateTime date;

  const Expenditures({
    required this.id,
    required this.amount,
    required this.category,
    required this.details,
    required this.date,
  });
}
