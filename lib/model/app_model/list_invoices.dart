import 'package:cln_common/cln_common.dart';

class AppListInvoices {
  List<AppInvoice> invoice;

  AppListInvoices({this.invoice = const []});

  factory AppListInvoices.fromJSON(Map<String, dynamic> json) {
    var invoices = json["invoices"] as List;
    if (invoices.isNotEmpty) {
      var appInvoices =
          invoices.map((invoice) => AppInvoice.fromJSON(invoice)).toList();
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
  final int amount;

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

  factory AppInvoice.fromJSON(Map<String, dynamic> json) {
    LogManager.getInstance.debug("$json");
    // FIXME: the propriety with in the JSON should follow the convention like the cln docs convention?
    return AppInvoice(
      bolt11: json["bolt11"],
      paymentHash: json["paymentHash"],
      status: json["status"],
      amount: int.parse(json["amountReceivedMsat"]["msat"].toString()),
      paidTime: json["paidAt"].toString(),
      description: json["description"],
      label: json["label"],
    );
  }
}
