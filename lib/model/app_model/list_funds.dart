import 'package:cln_common/cln_common.dart';

class AppListFunds {
  List<AppFund> fund;

  List<AppFundChannel> fundChannels;

  AppListFunds({this.fund = const [], this.fundChannels = const []});

  factory AppListFunds.fromJSON(Map<String, dynamic> json) {
    var funds = json["outputs"] as List;
    var fundChannels = json["channels"] as List;
    if (funds.isNotEmpty) {
      var appFunds = funds.map((fund) => AppFund.fromJSON(fund)).toList();
      var appFundChannels = fundChannels
          .map((channels) => AppFundChannel.fromJSON(channels))
          .toList();
      return AppListFunds(fund: appFunds, fundChannels: appFundChannels);
    } else {
      return AppListFunds();
    }
  }
}

class AppFund {
  /// Transaction identifier
  final String txId;

  /// The quantity of Bitcoin in millisatoshi
  final int amount;

  /// If the transaction is confirmed on the blockchain
  final String confirmed;

  /// If the transaction is reserved for another
  final bool reserved;

  /// flag to identify funds
  final String identifier;

  AppFund(
      {required this.txId,
      required this.amount,
      required this.confirmed,
      required this.reserved,
      this.identifier = "fund"});

  factory AppFund.fromJSON(Map<String, dynamic> json) {
    LogManager.getInstance.debug("$json");
    // FIXME: the propriety with in the JSON should follow the convention like the cln docs convention?
    return AppFund(
        txId: json["txid"],
        amount: int.parse(json["amountMsat"]["msat"].toString()),
        confirmed: json["status"],
        reserved: json["reserved"] ?? false);
  }
}

class AppFundChannel {
  /// Transaction identifier
  final String peerId;

  /// The quantity of Bitcoin in millisatoshi
  final int amount;

  /// If the transaction is confirmed on the blockchain
  final bool connected;

  /// If the transaction is reserved for another
  final String state;

  /// flag to identify funds
  final String fundingTxId;

  AppFundChannel(
      {required this.peerId,
      required this.amount,
      required this.connected,
      required this.state,
      required this.fundingTxId});

  factory AppFundChannel.fromJSON(Map<String, dynamic> json) {
    LogManager.getInstance.debug("$json");
    // FIXME: the propriety with in the JSON should follow the convention like the cln docs convention?
    return AppFundChannel(
        peerId: json["peerId"],
        amount: json["ourAmountMsat"]["msat"] != null
            ? int.parse(json["ourAmountMsat"]["msat"].toString())
            : 0,
        connected: json["connected"] ?? false,
        state: json["state"],
        fundingTxId: json["fundingTxid"]);
  }
}
