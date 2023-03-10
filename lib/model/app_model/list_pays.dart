import 'package:clnapp/model/app_model/app_utils.dart';

class AppListPays {
  List<AppPays> pays;

  AppListPays({this.pays = const []});

  factory AppListPays.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var pays = json.withKey("pays", snackCase: snackCase) as List;
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

  final String amountSentMSAT;

  final String createdAt;

  final String status;

  final String paymentHash;

  final String destination;

  final String identifier;

  AppPays(
      {required this.bolt11,
      required this.amountSentMSAT,
      required this.createdAt,
      required this.status,
      required this.destination,
      required this.paymentHash,
      this.identifier = "listpays"});

  factory AppPays.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var bolt11 = json.withKey("bolt11", snackCase: snackCase);
    var amountSentMSAT = json.parseMsat(
        key: "amountsentmsat", snackCase: snackCase, isObject: false);
    var createdAt = json.withKey("created_at", snackCase: snackCase);
    var status = json.withKey("status", snackCase: snackCase);
    var paymentHash = json.withKey("payment_hash", snackCase: snackCase);
    var destination = json.withKey("destination", snackCase: snackCase);

    /// Checking if the status of the pay is complete or not
    return AppPays(
        bolt11: bolt11,
        amountSentMSAT: amountSentMSAT,
        createdAt: createdAt.toString(),
        status: status,
        paymentHash: paymentHash,
        destination: destination);
  }
}
