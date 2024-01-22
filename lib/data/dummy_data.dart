import 'package:expense_tracker_app/data/categories.dart';
import 'package:expense_tracker_app/models/category.dart';
import 'package:expense_tracker_app/models/expenditures.dart';

final groceryItems = [
  Expenditures(
    id: 'a',
    details: "Yandex Taxi",
    amount: 10000,
    category: categories[Categories.transport]!,
    date: DateTime.now(),
  ),
  Expenditures(
    id: 'a',
    amount: 50000,
    category: categories[Categories.food]!,
    details: "Cambridge Cafe",
    date: DateTime.now(),
  ),
  Expenditures(
    id: 'a',
    amount: 100000,
    category: categories[Categories.health]!,
    details: "Medion",
    date: DateTime.now(),
  ),
];
