import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';
import 'package:bolt11_decoder/bolt11_decoder.dart' as pay_req;

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
  /// bolt11 identifier
  final String bolt11;

  /// The quantity of Bitcoin in millisatoshi
  final String amount;

  final String paymentRequest;

  final String prefix;

  final List<int> signature;

  final List<pay_req.TaggedField> tags;

  final String timeStamp;

  final String identifier;

  final String status;

  AppInvoice(
      {required this.bolt11,
      required this.amount,
      required this.paymentRequest,
      required this.prefix,
      required this.signature,
      required this.tags,
      required this.timeStamp,
      required this.status,
      this.identifier = "invoice"});

  factory AppInvoice.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false, bool isObject = false}) {
    LogManager.getInstance.debug("$json");
    var bolt11 = json.withKey("bolt11", snackCase: snackCase);
    var status = json.withKey("status", snackCase: snackCase);
    pay_req.Bolt11PaymentRequest req = pay_req.Bolt11PaymentRequest(bolt11);
    LogManager.getInstance.debug(
        "NEW RESPONSE HERE : ${req.amount} ${req.paymentRequest} ${req.prefix} ${req.signature} ${req.tags} ${req.timestamp}");
    var amount = req.amount;
    var paymentRequest = req.paymentRequest;
    var pre = req.prefix;
    String prefix = '';
    if (pre == pay_req.PayRequestPrefix.lntb) {
      prefix = "lntb";
    } else if (pre == pay_req.PayRequestPrefix.lnbcrt) {
      prefix = "lncbrt";
    } else if (pre == pay_req.PayRequestPrefix.lnbc) {
      prefix = "lnbc";
    } else {
      prefix = "lnsb";
    }
    var signature = req.signature;
    var tags = req.tags;
    var timeStamp = req.timestamp;
    return AppInvoice(
      bolt11: bolt11,
      amount: amount.toString(),
      status: status ?? "unpaid",
      paymentRequest: paymentRequest,
      prefix: prefix.toString(),
      signature: signature,
      tags: tags,
      timeStamp: timeStamp.toString(),
    );
  }
}
