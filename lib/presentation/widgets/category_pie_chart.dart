import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../../data/models/transaction_model.dart';

class CategoryPieChart extends ConsumerWidget {
  const CategoryPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty)
          return const Center(child: Text("No transactions"));

        // Aggregate by category
        final Map<String, double> dataMap = {};
        for (var t in transactions.where((t) => !t.isIncome)) {
          dataMap[t.category] = (dataMap[t.category] ?? 0) + t.amount;
        }

        final List<PieChartSectionData> sections = dataMap.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            title: entry.key,
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12),
          );
        }).toList();

        return SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
