
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/auth_provider.dart';
import '../providers/transactions_provider.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsNotifierProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);
    final balance = ref.watch(balanceProvider);
    final pieChartData = ref.watch(pieChartDataProvider);

    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) => RefreshIndicator(
          onRefresh: () => ref.read(transactionsNotifierProvider.notifier).fetchTransactions(),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSummaryCard(context, currencyFormat, totalIncome, totalExpenses, balance),
              const SizedBox(height: 24),
              if (pieChartData.isNotEmpty) _buildPieChart(context, pieChartData),
              const SizedBox(height: 24),
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (transactions.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('No transactions yet.')))
              else
                
                ...transactions.take(5).map((tx) => _buildTransactionTile(context, ref, tx, currencyFormat)),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  
  Widget _buildSummaryCard(BuildContext context, NumberFormat currencyFormat, double income, double expenses, double balance) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Balance', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
            Text(currencyFormat.format(balance), style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeExpenseColumn('Income', currencyFormat.format(income), Colors.white, Icons.arrow_upward),
                _buildIncomeExpenseColumn('Expenses', currencyFormat.format(expenses), Colors.white, Icons.arrow_downward),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildIncomeExpenseColumn(String title, String amount, Color color, IconData icon) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2), radius: 16, child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color.withOpacity(0.8), fontSize: 14)),
            const SizedBox(height: 4),
            Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, double> data) {
    final List<PieChartSectionData> sections = data.entries.map((entry) {
      final isTouched = false;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 90.0 : 80.0;
      return PieChartSectionData(
        color: Colors.primaries[data.keys.toList().indexOf(entry.key) % Colors.primaries.length].withOpacity(0.8),
        value: entry.value,
        title: '${entry.key}\n${NumberFormat.compact().format(entry.value)}',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: const [Shadow(color: Colors.black, blurRadius: 2)]),
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Expense Breakdown', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {}),
            ),
            swapAnimationDuration: const Duration(milliseconds: 350),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
      ],
    );
  }

  
  Widget _buildTransactionTile(BuildContext context, WidgetRef ref, Transaction tx, NumberFormat currencyFormat) {
    final isExpense = tx.isExpense;
    final color = isExpense ? Colors.redAccent : Colors.green;
    final icon = isExpense ? Icons.arrow_downward : Icons.arrow_upward;

    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      
      background: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
      
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: const Text("Are you sure you want to delete this transaction?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      
      onDismissed: (direction) {
        ref.read(transactionsNotifierProvider.notifier).deleteTransaction(tx.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tx.description} deleted.'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withAlpha((255 * 0.1).round()),
            child: Icon(icon, color: color),
          ),
          title: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(tx.category.name),
          trailing: Text(
            '${isExpense ? '-' : '+'}${currencyFormat.format(tx.amount)}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }
  
}