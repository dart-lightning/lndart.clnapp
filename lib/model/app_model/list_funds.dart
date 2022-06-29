class AppListFunds {
  List<AppFund> fund;

  AppListFunds({this.fund = const []});

  factory AppListFunds.fromJSON(Map<String, dynamic> json) {
    var funds = json["outputs"] as List;
    if (funds.isNotEmpty) {
      var appFunds = funds.map((fund) => AppFund.fromJSON(fund)).toList();
      return AppListFunds(fund: appFunds);
    } else {
      return AppListFunds();
    }
  }
}

class AppFund {
  final String txId;

  AppFund(this.txId);

  factory AppFund.fromJSON(Map<String, dynamic> json) => AppFund(json["txid"]);
}
