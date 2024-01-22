import 'dart:convert';

import 'package:expense_tracker_app/models/expenditures.dart';
import 'package:expense_tracker_app/models/individual_bar.dart';
import 'package:expense_tracker_app/provider/auth_provider.dart';
import 'package:expense_tracker_app/provider/expenses_provider.dart';
import 'package:expense_tracker_app/screens/details/details_screen.dart';
import 'package:expense_tracker_app/screens/home/bar_graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isToday(DateTime date) {
    final now = DateTime.now();

    // Remove the time component from both dates
    final dateWithoutTime = DateTime(date.year, date.month, date.day);
    final nowWithoutTime = DateTime(now.year, now.month, now.day);

    bool isToday = dateWithoutTime == nowWithoutTime;

    // Debug print
    print("Date: ${date.toIso8601String()}");
    print("Now: ${now.toIso8601String()}");
    print("Result: $isToday");

    return isToday;
  }

  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String getMonthName(DateTime date) {
    return monthNames[
        date.month - 1]; // Subtract 1 because the list is 0-indexed
  }

  @override
  void initState() {
    Provider.of<ExpensesProvider>(context, listen: false).loadItems();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpensesProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final currency = Provider.of<AuthProvider>(context).userCurrency;
    final weeklyExpenses = expenses.getWeeklyExpenses();
    Widget content = const Center(
      child: Text("No items added yet"),
    );
    if (expenses.expenditures.isNotEmpty) {
      content = Container(
        height: 700,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final item = expenses.expenditures[index];
            return Dismissible(
              onDismissed: (value) {
                expenses.removeExpenditure(item.id);
              },
              // background: Container(
              //   height: 20,
              //   width: 20,
              //   color: Colors.red,
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   alignment: AlignmentDirectional.centerEnd,
              //   child: Icon(
              //     Icons.delete,
              //     color: Colors.white,
              //   ),
              // ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you wish to delete this item?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("DELETE"),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Color(
                                0xff492A53,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("CANCEL"),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Color(
                                0xff492A53,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              key: ValueKey(expenses.expenditures[index].id),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isToday(expenses.expenditures[index].date)
                          ? "Today"
                          : "${expenses.expenditures[index].date.day} ${getMonthName(expenses.expenditures[index].date)}",
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                      // Other properties...
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side (image and texts)
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              // margin: const EdgeInsets.only(top: 30),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffEEE6EE),
                              ),
                              child: Image(
                                image:
                                    expenses.expenditures[index].category.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  expenses.expenditures[index].details,
                                  style: GoogleFonts.robotoCondensed(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  expenses.expenditures[index].category.title,
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.grey.shade400,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Right side (price)
                        Text(
                          "-${expenses.expenditures[index].amount} $currency",
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: expenses.expenditures.length,
        ),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff492A53),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (index) {
                return DetailsScreen();
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 36,
                            color: const Color(0xff120916),
                          ),
                        ),
                        Text(
                          "${auth.user?.displayName ?? "Null"}",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 40,
                            color: const Color(0xff120916),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black38,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xff492A53),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Expenses",
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${expenses.getTotalExpenses().toStringAsFixed(expenses.getTotalExpenses().truncateToDouble() == expenses.getTotalExpenses() ? 0 : 2)} $currency",
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 34,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffD2B6D7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: MyBarGraph(
                            weeklySummary: weeklyExpenses.values.toList(),
                            currency: currency,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
