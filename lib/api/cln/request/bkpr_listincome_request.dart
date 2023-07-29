import 'package:clnapp/api/cln/request/cln_request.dart';

class CLNListIncomeRequest extends CLNRequest {
  CLNListIncomeRequest({Map<String, dynamic>? unixRequest})
      : super(unixRequest: unixRequest);

  @override
  Map<String, dynamic> toMap() {
    return unixRequest!;
  }
}
