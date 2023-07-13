import 'package:clnapp/model/app_model/app_utils.dart';

/// For decoding the error messages from the Core lightning
class ErrorDecoder {
  final String message;

  ErrorDecoder({required this.message});

  factory ErrorDecoder.fromJSON(Map<String, dynamic> json) {
    Map<String, dynamic> temp = json.withKey("error");
    var message = temp.withKey("message");
    return ErrorDecoder(message: message);
  }
}
