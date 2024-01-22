import 'package:expense_tracker_app/models/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  final String currency;
  const MyBarGraph({
    super.key,
    required this.weeklySummary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      monAmount: weeklySummary[0],
      tueAmount: weeklySummary[1],
      wedAmount: weeklySummary[2],
      thuAmount: weeklySummary[3],
      friAmount: weeklySummary[4],
      satAmount: weeklySummary[5],
      sunAmount: weeklySummary[6],
    );
    myBarData.initializeData();
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: const Color(0xffC8B6B9),
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "Mon",
        style: style,
      );
      break;
    case 1:
      text = const Text(
        "Tue",
        style: style,
      );
      break;
    case 2:
      text = const Text(
        "Wed",
        style: style,
      );
      break;
    case 3:
      text = const Text(
        "Thu",
        style: style,
      );
      break;
    case 4:
      text = const Text(
        "Fri",
        style: style,
      );
      break;
    case 5:
      text = const Text(
        "Sat",
        style: style,
      );
      break;
    case 6:
      text = const Text(
        "Sun",
        style: style,
      );
      break;
    default:
      return Text("data");
  }
  return SideTitleWidget(
    child: text,
    axisSide: meta.axisSide,
  );
}
