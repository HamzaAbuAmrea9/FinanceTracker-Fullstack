
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import 'auth_provider.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final authState = ref.watch(authProvider);
  final apiService = ref.watch(apiServiceProvider);
  if (authState.status == AuthStatus.authenticated && authState.token != null) {
    return await apiService.getCategories(authState.token!);
  }
  return [];
});


final transactionsNotifierProvider = StateNotifierProvider<TransactionsNotifier, AsyncValue<List<Transaction>>>((ref) {
  return TransactionsNotifier(ref);
});

class TransactionsNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final Ref _ref;

  TransactionsNotifier(this._ref) : super(const AsyncLoading()) {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    state = const AsyncLoading();
    try {
      final authState = _ref.read(authProvider);
      final apiService = _ref.read(apiServiceProvider);
      if (authState.status == AuthStatus.authenticated && authState.token != null) {
        final transactions = await apiService.getTransactions(authState.token!);
        state = AsyncData(transactions);
      } else {
        state = const AsyncData([]);
      }
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    try {
      final authState = _ref.read(authProvider);
      final apiService = _ref.read(apiServiceProvider);
      if (authState.status == AuthStatus.authenticated && authState.token != null) {
        await apiService.createTransaction(authState.token!, transactionData);
        // Refresh the list after adding.
        fetchTransactions();
      }
    } catch (e) {
      
    }
  }

 

  
  Future<void> deleteTransaction(int transactionId) async {
    try {
      final authState = _ref.read(authProvider);
      final apiService = _ref.read(apiServiceProvider);
      if (authState.status == AuthStatus.authenticated && authState.token != null) {
        await apiService.deleteTransaction(authState.token!, transactionId);
        
        
        state = state.whenData((transactions) {
          return transactions.where((tx) => tx.id != transactionId).toList();
        });
      }
    } catch (e) {
      // If the API call fails, refetch the list to restore the deleted item.
      fetchTransactions();
    }
  }

  
}

// All the calculation providers for the transactions.
final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsNotifierProvider).asData?.value ?? [];
  return transactions
      .where((t) => !t.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);
});

final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsNotifierProvider).asData?.value ?? [];
  return transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);
});

final balanceProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expenses = ref.watch(totalExpensesProvider);
  return income - expenses;
});

final pieChartDataProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionsNotifierProvider).asData?.value ?? [];
  final expenses = transactions.where((t) => t.isExpense);
  
  Map<String, double> dataMap = {};
  for (var tx in expenses) {
    dataMap.update(
      tx.category.name,
      (value) => value + tx.amount,
      ifAbsent: () => tx.amount,
    );
  }
  return dataMap;
});