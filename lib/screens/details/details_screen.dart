import 'dart:convert';

import 'package:expense_tracker_app/data/categories.dart';
import 'package:expense_tracker_app/models/category.dart';
import 'package:expense_tracker_app/models/expenditures.dart';
import 'package:expense_tracker_app/provider/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredDetails = "";
  var _enteredQuantity = 0;
  var _selectedCategory = categories[Categories.transport]!;
  DateTime pickedDate = DateTime.now();
  DateTime _formatDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  Future<void> _pickedDate(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // Use Cupertino-style date picker for iOS
      showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: pickedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  pickedDate = newDate;
                });
              },
            ),
          );
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null && picked != pickedDate)
        setState(() {
          pickedDate = picked;
        });
    }
  }

  Future<void> saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the new expenditure
      final newExpenditure = Expenditures(
        id: DateTime.now().toString(),
        details: _enteredDetails,
        amount: _enteredQuantity,
        category: _selectedCategory,
        date: pickedDate,
      );

      Provider.of<ExpensesProvider>(context, listen: false)
          .addExpenditures(newExpenditure);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Details"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length > 15) {
                      return "You have to provide details, and details can contain no more than 15 characters";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _enteredDetails = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Amount"),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 1) {
                            return "There are some errors...Please, check for validation";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _enteredQuantity = int.parse(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: const Color(0xffD2B6D7),
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      category.value.icon,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(category.value.title)
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          _selectedCategory = value!;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff492A53),
                    foregroundColor: Colors.white, // Text color
                  ),
                  icon: Icon(Icons.calendar_today),
                  label: Text('Pick a date'),
                  onPressed: () {
                    _pickedDate(context);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          color: Color(0xff492A53),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff492A53)),
                      ),
                      onPressed: saveItem,
                      child: const Text(
                        "Save an Item",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
