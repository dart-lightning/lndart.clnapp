import 'package:clnapp/model/app_model/app_utils.dart';

class AppWithdraw {
  String tx;

  AppWithdraw({required this.tx});

  factory AppWithdraw.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var tx = json.withKey("tx", snackCase: snackCase)!;
    return AppWithdraw(tx: tx);
  }
}
