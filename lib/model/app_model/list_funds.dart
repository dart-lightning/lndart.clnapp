import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListFunds {
  List<AppFund> fund;

  List<AppFundChannel> fundChannels;

  int totOffChainMsat;

  AppListFunds(
      {this.fund = const [],
      this.fundChannels = const [],
      this.totOffChainMsat = 0});

  factory AppListFunds.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool isObject = false}) {
    LogManager.getInstance.debug("Full listfunds json received: $json");
    var funds = json.withKey("outputs", snackCase: snackCase) as List;
    LogManager.getInstance.debug("Funds: $funds");
    var fundChannels = json.withKey("channels", snackCase: snackCase) as List;
    LogManager.getInstance.debug("Channels: $fundChannels");
    double totalChannelsAmount = 0;
    for (var rawChannel in fundChannels) {
      var channel = Map<String, dynamic>.from(rawChannel);
      var ourAmountMsat = channel.parseMsat(
          key: "ourAmountMsat", snackCase: snackCase, isObject: isObject);
      if (ourAmountMsat.toString() != "unpaid") {
        totalChannelsAmount += int.parse(ourAmountMsat);
      }
    }

    /// converting Msat to sat
    totalChannelsAmount /= 1000;

    if (funds.isNotEmpty || fundChannels.isNotEmpty) {
      var appFunds = funds
          .map((fund) =>
              AppFund.fromJSON(fund, snackCase: snackCase, isObject: isObject))
          .toList();
      var appFundChannels = fundChannels
          .map((channels) => AppFundChannel.fromJSON(channels,
              snackCase: snackCase, isObject: isObject))
          .toList();
      return AppListFunds(
          fund: appFunds,
          fundChannels: appFundChannels,
          totOffChainMsat: totalChannelsAmount.toInt());
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
      {bool snackCase = false, bool isObject = false}) {
    LogManager.getInstance.debug("$json");
    var txId = json.withKey("txid", snackCase: snackCase);
    var ourAmount = json.parseMsat(
        key: "amountMsat", snackCase: snackCase, isObject: isObject);
    var status = json.withKey("status", snackCase: snackCase);
    var reserved = json.withKey("reserved", snackCase: snackCase);
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
      {bool snackCase = false, bool isObject = false}) {
    LogManager.getInstance.debug("$json");
    var peerID = json.withKey("peerId", snackCase: snackCase);
    var ourAmount = json.parseMsat(
        key: "ourAmountMsat", snackCase: snackCase, isObject: isObject);
    var connected = json.withKey("connected", snackCase: snackCase);
    var state = json.withKey("state", snackCase: snackCase);
    var fundingTxId = json.withKey("fundingTxid", snackCase: snackCase);
    return AppFundChannel(
        peerId: peerID,
        amount: ourAmount,
        connected: connected ?? false,
        state: state,
        fundingTxId: fundingTxId);
  }
}
