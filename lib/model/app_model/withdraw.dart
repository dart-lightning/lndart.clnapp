import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppWithdraw {
  String tx;

  AppWithdraw({required this.tx});

  factory AppWithdraw.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("Response : $json");
    var tx = json.withKey("tx", snackCase: snackCase)!;
    return AppWithdraw(tx: tx);
  }
}
