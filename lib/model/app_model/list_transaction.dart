import 'package:clnapp/model/app_model/app_utils.dart';

class AppListTransactions {
  List<AppTransaction> transactions;

  AppListTransactions({this.transactions = const []});

  factory AppListTransactions.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var transactions =
        json.withKey("transactions", snackCase: snackCase) as List;
    if (transactions.isNotEmpty) {
      var appTransactions = transactions
          .map((transaction) =>
              AppTransaction.fromJSON(transaction, snackCase: snackCase))
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

  factory AppTransaction.fromJSON(Map<String, dynamic> json,
          {bool snackCase = false}) =>
      AppTransaction(json["hash"]);
}
