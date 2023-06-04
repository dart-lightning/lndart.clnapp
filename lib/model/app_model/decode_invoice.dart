import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppDecodeInvoice {
  DecodeInvoice invoice;
  AppDecodeInvoice(this.invoice);

  factory AppDecodeInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("RESPONSE HERE : $json");
    var decodedInvoice = DecodeInvoice.fromJSON(json, snackCase: snackCase);
    return AppDecodeInvoice(decodedInvoice);
  }
}

class DecodeInvoice {
  String description;

  int expirationTime;

  String pubKey;

  int amount;

  int createdTime;

  DecodeInvoice(
      {required this.description,
      required this.amount,
      required this.expirationTime,
      required this.pubKey,
      required this.createdTime});

  factory DecodeInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var description = json.withKey("description", snackCase: !snackCase);
    var expirationTime = json.withKey("expiry", snackCase: !snackCase);
    var amount = json.withKey("amount_msat", snackCase: snackCase);
    var pubKey = json.withKey("payee", snackCase: !snackCase);
    var createdTime = json.withKey("createdAt", snackCase: snackCase);
    return DecodeInvoice(
        description: description,
        expirationTime: expirationTime,
        pubKey: pubKey,
        createdTime: createdTime,
        amount: amount ?? 0);
  }
}
