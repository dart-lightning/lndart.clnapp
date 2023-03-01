import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListTransactions {
  List<AppTransaction> transactions;

  AppListTransactions({this.transactions = const []});

  factory AppListTransactions.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("Full listfunds json received : $json");
    var transactions =
        json.withKey("transactions", snackCase: snackCase) as List;
    LogManager.getInstance
        .debug("Full listfunds transactions received : $transactions");
    if (transactions.isNotEmpty) {
      var appTransactions = transactions
          .map((hash) => AppTransaction.fromJSON(hash, snackCase: snackCase))
          .toList();
      return AppListTransactions(transactions: appTransactions);
    } else {
      return AppListTransactions();
    }
  }
}

class AppTransaction {
  final String txId;

  final String identifier;

  AppTransaction({required this.txId, this.identifier = "transaction"});

  factory AppTransaction.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var hash = json.withKey("hash", snackCase: snackCase);
    LogManager.getInstance.debug("Final app transaction here : $hash");
    return AppTransaction(txId: hash);
  }
}
