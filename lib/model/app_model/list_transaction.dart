class AppListTransactions {
  List<AppTransaction> transactions;

  AppListTransactions({this.transactions = const []});

  factory AppListTransactions.fromJSON(Map<String, dynamic> json) {
    var transactions = json["transactions"] as List;
    if (!transactions.isNotEmpty) {
      var appTransactions = transactions
          .map((transaction) => AppTransaction.fromJSON(transaction))
          .toList();
      return AppListTransactions(transactions: appTransactions);
    } else {
      return AppListTransactions();
    }
  }
}

class AppTransaction {
  final String txId;

  AppTransaction(this.txId);

  factory AppTransaction.fromJSON(Map<String, dynamic> json) =>
      AppTransaction(json["txId"]);
}
