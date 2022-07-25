import 'package:recase/recase.dart';

dynamic witKey(
    {required String key,
    required Map<String, dynamic> json,
    bool snackCase = false}) {
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
      bool snackCase = false}) {
    if (snackCase) {
      return json[key.snakeCase];
    }
    return json[key.camelCase];
  }
}

extension RecaseMap on Map<String, dynamic> {
  dynamic withKey(String key, {bool snackCase = false}) =>
      AppUtil(key).witKey(key: key, json: this, snackCase: snackCase);
}
