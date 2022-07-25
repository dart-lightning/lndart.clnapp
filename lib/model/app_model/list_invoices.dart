import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListInvoices {
  List<AppInvoice> invoice;

  AppListInvoices({this.invoice = const []});

  factory AppListInvoices.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var invoices = json.withKey("invoices", snackCase: snackCase) as List;
    if (invoices.isNotEmpty) {
      var appInvoices = invoices
          .map((invoice) => AppInvoice.fromJSON(invoice, snackCase: snackCase))
          .toList();
      return AppListInvoices(invoice: appInvoices);
    } else {
      return AppListInvoices();
    }
  }
}

class AppInvoice {
  /// payment hash
  final String paymentHash;

  /// bolt11 identifier
  final String bolt11;

  /// The quantity of Bitcoin in millisatoshi
  final String amount;

  /// If the invoice is paid or not on the blockchain
  final String status;

  /// The Invoice paid time
  final String paidTime;

  /// The Invoice description
  final String label;

  /// The Invoice description
  final String description;

  /// flag to identify invoice
  final String identifier;

  AppInvoice(
      {required this.paymentHash,
      required this.amount,
      required this.status,
      required this.paidTime,
      required this.bolt11,
      required this.description,
      required this.label,
      this.identifier = "invoice"});

  factory AppInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("$json");
    var bolt11 = witKey(key: "bolt11", json: json, snackCase: snackCase);
    var paymentHash =
        witKey(key: "paymentHash", json: json, snackCase: snackCase);
    var status = witKey(key: "status", json: json, snackCase: snackCase);
    var received =
        witKey(key: "amountReceivedMsat", json: json, snackCase: snackCase);
    var paidAt = witKey(key: "paidAt", json: json, snackCase: snackCase);
    var description =
        witKey(key: "description", json: json, snackCase: snackCase);
    var label = witKey(key: "label", json: json, snackCase: snackCase);
    return AppInvoice(
      bolt11: bolt11,
      paymentHash: paymentHash,
      status: status ?? "unpaid",
      amount: received != null ? received["msat"].toString() : "unpaid",
      paidTime: paidAt ?? "unpaid",
      description: description,
      label: label,
    );
  }
}
