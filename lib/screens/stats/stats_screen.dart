import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/expenses_provider.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    var expensesProvider = Provider.of<ExpensesProvider>(context);
    final currency = Provider.of<AuthProvider>(context).userCurrency;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expenses Statistics',
          style: GoogleFonts.robotoCondensed(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return const Color(
                0xffD2B6D7); // make the header row have a different color
          }),
          columnSpacing: 38,
          dataRowHeight: 60,
          headingRowHeight: 56,
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey.shade300), // table border color
          ),
          columns: const <DataColumn>[
            DataColumn(
                label: Text('Date',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Detail',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Amount',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: expensesProvider.expenditures.map((expenditure) {
            return DataRow(
              color: MaterialStateProperty.all<Color>(Color(0xffEEE6EE)),
              cells: <DataCell>[
                DataCell(Text(DateFormat('yyyy-MM-dd').format(expenditure.date),
                    style: TextStyle(color: Colors.grey.shade600))),
                DataCell(Text(expenditure.category.title,
                    style: TextStyle(color: Colors.grey.shade600))),
                DataCell(Text(expenditure.details,
                    style: TextStyle(color: Colors.grey.shade600))),
                DataCell(
                  Text(
                    '-${expenditure.amount} $currency',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
