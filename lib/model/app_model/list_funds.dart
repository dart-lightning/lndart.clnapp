import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListFunds {
  List<AppFund> fund;

  List<AppFundChannel> fundChannels;

  int channelSats;

  AppListFunds(
      {this.fund = const [],
      this.fundChannels = const [],
      this.channelSats = 0});

  factory AppListFunds.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool msatFlag = false}) {
    LogManager.getInstance.debug("Full listfunds json received: $json");
    var funds = witKey(
        key: "outputs",
        json: json,
        snackCase: snackCase,
        msatFlag: msatFlag) as List;
    LogManager.getInstance.debug("$funds");
    var fundChannels = witKey(
        key: "channels",
        json: json,
        snackCase: snackCase,
        msatFlag: msatFlag) as List;
    double totalChannelsAmount = 0;
    for (var channel in fundChannels) {
      var ourAmountMsat = witKey(
              key: "ourAmountMsat",
              json: channel,
              snackCase: snackCase,
              msatFlag: true) ??
          "0";
      ourAmountMsat.toString();
      totalChannelsAmount += int.parse(ourAmountMsat ?? "0");
    }

    /// converting Msat to sat
    totalChannelsAmount /= 1000;

    if (funds.isNotEmpty) {
      var appFunds = funds
          .map((fund) => AppFund.fromJSON(fund, snackCase: snackCase))
          .toList();
      var appFundChannels = fundChannels
          .map((channels) =>
              AppFundChannel.fromJSON(channels, snackCase: snackCase))
          .toList();
      return AppListFunds(
          fund: appFunds,
          fundChannels: appFundChannels,
          channelSats: totalChannelsAmount.toInt());
    } else {
      return AppListFunds();
    }
  }
}

class AppFund {
  /// Transaction identifier
  final String txId;

  /// The quantity of Bitcoin in millisatoshi
  final String amount;

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

  factory AppFund.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool msatFlag = false}) {
    LogManager.getInstance.debug("$json");
    var txId = witKey(key: "txid", json: json, snackCase: snackCase);
    var ourAmount = witKey(
            key: "amountMsat",
            json: json,
            snackCase: snackCase,
            msatFlag: true) ??
        0;
    ourAmount.toString();
    var status = witKey(key: "status", json: json, snackCase: snackCase);
    var reserved = witKey(key: "reserved", json: json, snackCase: snackCase);
    return AppFund(
        txId: txId,
        amount: ourAmount,
        confirmed: status,
        reserved: reserved ?? false);
  }
}

class AppFundChannel {
  /// Transaction identifier
  final String peerId;

  /// The quantity of Bitcoin in millisatoshi
  final String amount;

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

  factory AppFundChannel.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool msatFlag = false}) {
    LogManager.getInstance.debug("$json");
    var peerID = witKey(key: "peerId", json: json, snackCase: snackCase);
    var ourAmount = witKey(
            key: "ourAmountMsat",
            json: json,
            snackCase: snackCase,
            msatFlag: true) ??
        0;
    ourAmount.toString();
    var connected = witKey(key: "connected", json: json, snackCase: snackCase);
    var state = witKey(key: "state", json: json, snackCase: snackCase);
    var fundingTxId =
        witKey(key: "fundingTxid", json: json, snackCase: snackCase);
    return AppFundChannel(
        peerId: peerID,
        amount: ourAmount,
        connected: connected ?? false,
        state: state,
        fundingTxId: fundingTxId);
  }
}
