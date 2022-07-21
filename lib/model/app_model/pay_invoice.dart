import 'package:cln_common/cln_common.dart';

class AppPayInvoice {
  Map<String, dynamic> payResponse;

  AppPayInvoice({required this.payResponse});

  factory AppPayInvoice.fromJSON(Map<String, dynamic> json) {
    var payResponse = json;
    LogManager.getInstance.debug("$json");
    if (payResponse.isNotEmpty) {
      return AppPayInvoice(payResponse: payResponse);
    } else {
      return AppPayInvoice(payResponse: json);
    }
  }
}
