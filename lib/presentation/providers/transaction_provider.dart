import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

// Stream of transactions
final transactionsProvider = StreamProvider<List<TransactionModel>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getTransactions();
});

// Actions: Add/Delete
final transactionActionProvider = Provider<TransactionActionProvider>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return TransactionActionProvider(repo);
});

class TransactionActionProvider {
  final TransactionRepository _repo;
  TransactionActionProvider(this._repo);

  Future<void> add(TransactionModel transaction) async {
    await _repo.addTransaction(transaction);
  }

  Future<void> delete(String id) async {
    await _repo.deleteTransaction(id);
  }
}
