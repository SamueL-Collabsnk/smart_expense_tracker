import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../../data/models/transaction_model.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(child: Text("No transactions yet"));
        }
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final t = transactions[index];
            return Card(
              child: ListTile(
                title: Text(t.title),
                subtitle: Text("${t.category} - ${t.date.toLocal()}"),
                trailing: Text(
                  "${t.isIncome ? '+' : '-'} \$${t.amount.toStringAsFixed(2)}",
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
