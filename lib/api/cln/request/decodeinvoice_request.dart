import 'package:clnapp/api/cln/request/cln_request.dart';

/// FIXME: Add support for GRPC
class CLNDecodeInvoiceRequest extends CLNRequest {
  CLNDecodeInvoiceRequest({Map<String, dynamic>? unixRequest})
      : super(unixRequest: unixRequest);

  @override
  Map<String, dynamic> toMap() {
    return unixRequest!;
  }
}
