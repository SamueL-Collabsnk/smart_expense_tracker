import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../providers/transaction_provider.dart';
import '../../../data/models/transaction_model.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = 'Food';
  bool _isIncome = false;
  bool _loading = false;

  final List<String> categories = [
    'Food', 'Transport', 'Rent', 'Shopping', 'Entertainment', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final transactionActions = ref.watch(transactionActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _category,
              items: categories.map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            Row(
              children: [
                const Text('Income'),
                Switch(
                  value: _isIncome,
                  onChanged: (value) {
                    setState(() => _isIncome = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      final transaction = TransactionModel(
                        id: const Uuid().v4(),
                        title: _titleController.text.trim(),
                        amount: double.tryParse(_amountController.text.trim()) ?? 0,
                        category: _category,
                        date: DateTime.now(),
                        isIncome: _isIncome,
                      );
                      await transactionActions.add(transaction);
                      if (context.mounted) Navigator.pop(context);
                      setState(() => _loading = false);
                    },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}

