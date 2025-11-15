import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../../data/models/transaction_model.dart';

class WeeklyBarChart extends ConsumerWidget {
  const WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty)
          return const Center(child: Text("No transactions"));

        // Aggregate by weekday
        final Map<int, double> dataMap = {
          0: 0,
          1: 0,
          2: 0,
          3: 0,
          4: 0,
          5: 0,
          6: 0,
        };
        for (var t in transactions) {
          final weekday = t.date.weekday % 7; // Sunday=0
          dataMap[weekday] = (dataMap[weekday] ?? 0) + t.amount;
        }

        final bars = dataMap.entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [BarChartRodData(toY: entry.value, color: Colors.indigo)],
          );
        }).toList();

        return SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                      return Text(days[value.toInt()]);
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: bars,
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
