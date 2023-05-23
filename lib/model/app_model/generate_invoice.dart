import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppGenerateInvoice {
  AppInvoice invoice;

  AppGenerateInvoice(this.invoice);

  factory AppGenerateInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("RESPONSE HERE : $json");
    var invoice = AppInvoice.fromJSON(json);
    return AppGenerateInvoice(invoice);
  }
}

class AppInvoice {
  final String paymentHash;

  final int expiresAt;

  final String bolt11;

  final String paymentSecret;

  AppInvoice(
      {required this.paymentHash,
      required this.bolt11,
      required this.expiresAt,
      required this.paymentSecret});

  factory AppInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var paymentHash = json.withKey("payment_hash", snackCase: true);
    var bolt11 = json.withKey("bolt11", snackCase: true);
    var paymentSecret = json.withKey("payment_secret", snackCase: true);
    var expiresAt = json.withKey("expires_at", snackCase: true);

    return AppInvoice(
        paymentHash: paymentHash,
        bolt11: bolt11,
        expiresAt: expiresAt,
        paymentSecret: paymentSecret);
  }
}
