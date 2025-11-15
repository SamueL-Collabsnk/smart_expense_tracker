import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/transaction_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to transactions collection
  CollectionReference get _transactions =>
      _firestore.collection('transactions');

  // Add a transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactions.doc(transaction.id).set(transaction.toJson());
  }

  // Update a transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactions.doc(transaction.id).update(transaction.toJson());
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await _transactions.doc(id).delete();
  }

  // Stream of all transactions
  Stream<List<TransactionModel>> getTransactions() {
    return _transactions.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    });
  }
}
