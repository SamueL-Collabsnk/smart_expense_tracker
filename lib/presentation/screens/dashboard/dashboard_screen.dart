import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transaction_provider.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../../widgets/transactions_list.dart';
import '../../widgets/category_pie_chart.dart';
import '../../widgets/weekly_bar_chart.dart';
import '../../../data/models/transaction_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // Calculate total income or expense
  double calculateTotal(List<TransactionModel> transactions, bool income) {
    return transactions
        .where((t) => t.isIncome == income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Expense Tracker')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          final totalIncome = calculateTotal(transactions, true);
          final totalExpense = calculateTotal(transactions, false);
          final balance = totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                Card(
                  color: Colors.indigo.shade100,
                  child: ListTile(
                    title: const Text(
                      'Balance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Income / Expense Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Colors.green.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text('Income'),
                            Text(
                              '\$${totalIncome.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.red.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text('Expense'),
                            Text(
                              '\$${totalExpense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Weekly Bar Chart
                const Text(
                  'Weekly Spending',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const WeeklyBarChart(),

                const SizedBox(height: 24),

                // Category Pie Chart
                const Text(
                  'Expenses by Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const CategoryPieChart(),

                const SizedBox(height: 24),

                // Transactions List
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height:
                      400, // set a fixed height to make it scrollable inside SingleChildScrollView
                  child: const TransactionsList(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
