import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppWithdraw {
  String txId;

  AppWithdraw({required this.txId});

  factory AppWithdraw.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("Response : $json");
    var txId = json.withKey("txid", snackCase: snackCase)!;
    return AppWithdraw(txId: txId);
  }
}
