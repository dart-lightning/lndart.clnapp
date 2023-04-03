import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';
import 'package:bolt11_decoder/bolt11_decoder.dart' as pay_req;

class AppListInvoices {
  List<AppInvoice> invoice;

  AppListInvoices({this.invoice = const []});

  factory AppListInvoices.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool isObject = false, String? status}) {
    var invoices = json.withKey("invoices", snackCase: snackCase) as List;
    List<AppInvoice> list = [];

    if (invoices.isNotEmpty) {
      for (var invoices in invoices) {
        AppInvoice temp = AppInvoice.fromJSON(invoices,
            snackCase: snackCase, isObject: isObject);

        /// Filtering the invoices on the basis of status
        if (temp.status == status) {
          list.add(temp);
        }
      }
      return AppListInvoices(invoice: list);
    } else {
      return AppListInvoices();
    }
  }
}

class AppInvoice {
  /// bolt11 identifier
  final String? bolt11;

  final String? bolt12;

  /// The quantity of Bitcoin in millisatoshi
  final String amount;

  final String identifier;

  final String status;

  final String description;

  final String boltIdentifier;

  AppInvoice(
      {required this.bolt11,
      required this.bolt12,
      required this.amount,
      required this.status,
      required this.description,
      required this.boltIdentifier,
      this.identifier = "invoice"});

  factory AppInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool isObject = false}) {
    LogManager.getInstance.debug("$json");
    String amount;
    String? bolt11;
    String? bolt12;
    String boltidentifier;

    /// Checking the type of bolt in the invoices.
    if (json.withKey("bolt11") == null) {
      bolt12 = json.withKey("bolt12");
      boltidentifier = "bolt12";

      /// Assuming the invoice is not paid.
      amount = json.withKey("amount_msat").toString();
    } else {
      bolt11 = json.withKey("bolt11", snackCase: snackCase);
      pay_req.Bolt11PaymentRequest req = pay_req.Bolt11PaymentRequest(bolt11!);

      /// Amount returned by the package is in bitcoins and amount received from the listinvoices is in msats
      /// Converting msats into btc
      amount = (double.parse(req.amount.toString()) * 100000000000).toString();
      boltidentifier = "bolt11";
    }
    var status = json.withKey("status", snackCase: snackCase);

    /// If the invoice is paid there is no key with "amount_msat" instead there is a key with "amount_recieved_msat"
    if (status == "paid" && boltidentifier == "bolt12") {
      amount =
          json.withKey("amount_received_msat", snackCase: snackCase).toString();
    }
    var description = json.withKey("description", snackCase: snackCase);
    return AppInvoice(
      bolt11: bolt11,
      bolt12: bolt12,
      boltIdentifier: boltidentifier,
      amount: amount.toString(),
      status: status ?? "unpaid",
      description: description ?? "No description for this invoice",
    );
  }
}
