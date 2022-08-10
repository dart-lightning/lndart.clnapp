import 'package:recase/recase.dart';

@Deprecated("please use the mixing implementation over Map<String, dynamic>")
dynamic witKey(
    {required String key,
    required Map<String, dynamic> json,
    bool snackCase = false}) {}

extension RecaseMap on Map<String, dynamic> {
  dynamic withKey(String key, {bool snackCase = false, bool msatFlag = false}) {
    if (snackCase) {
      return this[key.snakeCase];
    }
    return this[key.camelCase];
  }

  String parseMsat(
      {required String key, bool snackCase = false, bool isObject = false}) {
    var number = withKey(key, snackCase: snackCase);
    if (number == null) {
      return "unpaid";
    }
    if (isObject) {
      return number["msat"]?.toString() ?? "unpaid";
    }
    var numStr = number.toString();
    if (!numStr.contains("msat")) {
      return numStr;
    }
    return numStr.split("msat")[0];
  }
}
