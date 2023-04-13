import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppGenerateInvoice {
  AppGenerate generateResponse;

  AppGenerateInvoice({required this.generateResponse});

  factory AppGenerateInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("RESPONSE HERE : $json");
    var invoiceResponse = AppGenerate.fromJSON(json);
    return AppGenerateInvoice(generateResponse: invoiceResponse);
  }
}

class AppGenerate {
  final String invoice;
  final String expiresAt;
  final String paymentSecret;
  final String paymentHash;
  final String? warningCapacity;

  AppGenerate({
    required this.invoice,
    required this.paymentHash,
    required this.expiresAt,
    required this.paymentSecret,
    this.warningCapacity,
  });

  factory AppGenerate.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var invoice = json.withKey("bolt11", snackCase: snackCase);
    var paymentHash = json.parseMsat(key: "payment_hash", snackCase: true);
    var expiresAt = json.withKey("expires_at", snackCase: true);
    var paymentSecret = json.withKey("payment_secret", snackCase: true);
    var warningCapacity = json.withKey("warning_capacity", snackCase: true);
    return AppGenerate(
        paymentHash: paymentHash,
        expiresAt: expiresAt.toString(),
        paymentSecret: paymentSecret,
        warningCapacity: warningCapacity,
        invoice: invoice);
  }
}
