import 'package:clnapp/model/app_model/app_utils.dart';

class AppListSendPays {
  List<AppSendPays> pays;

  AppListSendPays({this.pays = const []});

  factory AppListSendPays.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var pays = json.withKey("payments", snackCase: snackCase) as List;
    if (pays.isNotEmpty) {
      var appSendPays = pays
          .map((pays) => AppSendPays.fromJSON(pays, snackCase: snackCase))
          .toList();
      return AppListSendPays(pays: appSendPays);
    } else {
      return AppListSendPays();
    }
  }
}

class AppSendPays {
  final String bolt11;

  final String paymentPreimage;

  final String createdAt;

  final String status;

  final String paymentHash;

  final String destination;

  final String label;

  final String identifier;

  final String amountSent;

  AppSendPays(
      {required this.bolt11,
      required this.paymentPreimage,
      required this.createdAt,
      required this.status,
      required this.destination,
      required this.paymentHash,
      required this.label,
      required this.amountSent,
      this.identifier = "listSendPays"});

  factory AppSendPays.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var bolt11 = json.withKey("bolt11", snackCase: snackCase);
    var paymentPreimage =
        json.parseMsat(key: "payment_preimage", snackCase: snackCase);
    var createdAt = json.withKey("created_at", snackCase: snackCase);
    var status = json.withKey("status", snackCase: snackCase);
    var paymentHash = json.withKey("payment_hash", snackCase: snackCase);
    var destination = json.withKey("destination", snackCase: snackCase);
    var label = json.withKey("label", snackCase: snackCase);
    var amountSent = json.withKey("amount_sent_msat", snackCase: snackCase);

    /// Checking if the status of the pay is complete or not
    return AppSendPays(
        bolt11: bolt11 ?? "No bolt11 for this transaction",
        paymentPreimage: paymentPreimage,
        createdAt: createdAt.toString(),
        status: status,
        paymentHash: paymentHash,
        destination: destination ?? "No destination",
        amountSent: amountSent.toString(),
        label: label ?? "No label provided for the payment");
  }
}
