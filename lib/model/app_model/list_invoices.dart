import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListInvoices {
  List<AppInvoice> invoice;

  AppListInvoices({this.invoice = const []});

  factory AppListInvoices.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool isObject = false, String? status}) {
    var invoices = json.withKey("invoices", snackCase: snackCase) as List;
    if (invoices.isNotEmpty) {
      var appInvoices = invoices.map((invoice) {
        var temp = AppInvoice.fromJSON(invoice,
            snackCase: snackCase, isObject: isObject);
        if (temp.status == status) {
          return temp;
        }
      }).toList();
      if (appInvoices.contains(null)) {
        return AppListInvoices();
      }
      return AppListInvoices(invoice: appInvoices as List<AppInvoice>);
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
      {bool snackCase = false, bool isObject = false}) {
    LogManager.getInstance.debug("$json");
    var bolt11 = json.withKey("bolt11", snackCase: snackCase) ??
        json.withKey("bolt12", snackCase: snackCase);
    var paymentHash = json.withKey("paymentHash", snackCase: snackCase);
    var status = json.withKey("status", snackCase: snackCase);
    var received = json.parseMsat(
        key: "amountReceivedMsat", snackCase: snackCase, isObject: isObject);
    received.toString();
    var paidAt = json.withKey("paidAt", snackCase: snackCase);
    var description = json.withKey("description", snackCase: snackCase);
    var label = json.withKey("label", snackCase: snackCase);
    return AppInvoice(
      bolt11: bolt11,
      paymentHash: paymentHash,
      status: status ?? "unpaid",
      amount: received.toString(),
      paidTime: paidAt != null ? paidAt.toString() : "unpaid",
      description: description,
      label: label,
    );
  }
}
