import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppPayInvoice {
  AppPay payResponse;

  AppPayInvoice({required this.payResponse});

  //TODO: how manage this? looks incompleted.
  factory AppPayInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("RESPONSE HERE : $json");
    var payResponse = AppPay.fromJSON(json);
    return AppPayInvoice(payResponse: payResponse);
  }
}

class AppPay {
  final String destination;

  final String paymentHash;

  final String createdAt;

  // amount that the recipient received
  final String amountMSAT;

  final String paymentPreimage;

  final String status;

  // amount that we sent including the fees.
  final String amountSentMSAT;

  AppPay({
    required this.destination,
    required this.paymentPreimage,
    required this.createdAt,
    required this.status,
    required this.amountMSAT,
    required this.paymentHash,
    required this.amountSentMSAT,
  });

  factory AppPay.fromJSON(Map<String, dynamic> json, {bool snackCase = false}) {
    var destination = json.withKey("destination", snackCase: snackCase);
    var paymentPreimage = json.withKey("payment_preimage", snackCase: true);
    var createdAt = json.withKey("created_at", snackCase: true);
    var status = json.withKey("status", snackCase: snackCase);
    var paymentHash = json.withKey("payment_hash", snackCase: true);
    var amountSent = json.withKey("amount_sent_msat", snackCase: true);
    var amountMSAT2 = json.withKey("amount_msat", snackCase: true);

    return AppPay(
        paymentPreimage: paymentPreimage,
        createdAt: createdAt.toString(),
        status: status,
        paymentHash: paymentHash.toString(),
        destination: destination ?? "No destination specified",
        amountSentMSAT: amountSent.toString(),
        amountMSAT: amountMSAT2.toString());
  }
}
