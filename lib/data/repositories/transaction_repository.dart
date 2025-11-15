import '../datasources/remote/firebase_service.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> addTransaction(TransactionModel transaction) async {
    await _firebaseService.addTransaction(transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _firebaseService.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _firebaseService.deleteTransaction(id);
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _firebaseService.getTransactions();
  }
}
