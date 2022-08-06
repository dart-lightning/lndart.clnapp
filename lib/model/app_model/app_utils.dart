import 'package:recase/recase.dart';

dynamic witKey(
    {required String key,
    required Map<String, dynamic> json,
    bool snackCase = false,
    bool msatFlag = false}) {
  /// FIXME: msatFlag is used to extract millisatoshi value from the client response.
  if (msatFlag) {
    if (snackCase) {
      if (json[key.snakeCase] == null) {
        return "0";
      }
      return json[key.snakeCase].toString();
    }
    if (json[key.camelCase] == null) {
      return "0";
    }
    return json[key.camelCase]["msat"] ?? "0";
  }
  if (snackCase) {
    return json[key.snakeCase];
  }
  return json[key.camelCase];
}

class AppUtil {
  String string;

  AppUtil(this.string);

  dynamic witKey(
      {required String key,
      required Map<String, dynamic> json,
      bool snackCase = false,
      bool msatFlag = false}) {
    if (snackCase) {
      return json[key.snakeCase];
    }
    return json[key.camelCase];
  }
}

extension RecaseMap on Map<String, dynamic> {
  dynamic withKey(String key,
          {bool snackCase = false, bool msatFlag = false}) =>
      AppUtil(key).witKey(
          key: key, json: this, snackCase: snackCase, msatFlag: msatFlag);
}
