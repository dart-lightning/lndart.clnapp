import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListPays {
  List<AppPays> pays;

  AppListPays({this.pays = const []});

  factory AppListPays.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var pays = json.withKey("pays", snackCase: snackCase) as List;

    LogManager.getInstance.debug("TRANSACTIONS ARE HERE: !!$pays");
    if (pays.isNotEmpty) {
      var appPays = pays
          .map((pays) => AppPays.fromJSON(pays, snackCase: snackCase))
          .toList();
      return AppListPays(pays: appPays);
    } else {
      return AppListPays();
    }
  }
}

class AppPays {
  final String bolt11;

  /// The quantity of Bitcoin in millisatoshi
  final String amount_sent_msat;

  /// If the transaction is confirmed on the blockchain
  final String createdat;

  /// If the transaction is reserved for another
  final String status;

  /// flag to identify funds
  final String paymenthash;

  final String destination;

  final String identifier;

  AppPays(
      {required this.bolt11,
      required this.amount_sent_msat,
      required this.createdat,
      required this.status,
      required this.destination,
      required this.paymenthash,
      this.identifier = "listpays"});

  factory AppPays.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var bolt11 = json.withKey("bolt11", snackCase: snackCase);
    var amount_sent_msat = json.parseMsat(
        key: "amountsentmsat", snackCase: snackCase, isObject: false);
    var createdat = json.withKey("created_at", snackCase: snackCase);
    var status = json.withKey("status", snackCase: snackCase);
    var paymenthash = json.withKey("payment_hash", snackCase: snackCase);
    var destination = json.withKey("destination", snackCase: snackCase);

    /// Checking if the status of the pay is complete or not
    return AppPays(
        bolt11: bolt11,
        amount_sent_msat: amount_sent_msat,
        createdat: createdat.toString(),
        status: status,
        paymenthash: paymenthash,
        destination: destination);
  }
}
