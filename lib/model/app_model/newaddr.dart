import 'package:clnapp/model/app_model/app_utils.dart';

class AppNewAddr {
  String bech32;

  AppNewAddr({required this.bech32});

  factory AppNewAddr.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var bech32 = json.withKey("bech32", snackCase: snackCase)!;
    return AppNewAddr(bech32: bech32);
  }
}
