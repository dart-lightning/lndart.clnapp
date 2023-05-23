import 'package:cln_grpc/cln_grpc.dart';
import 'cln_request.dart';

class CLNGenerateInvoiceRequest extends CLNRequest<InvoiceRequest> {
  CLNGenerateInvoiceRequest(
      {Map<String, dynamic>? unixRequest, InvoiceRequest? grpcRequest})
      : super(unixRequest: unixRequest, grpcRequest: grpcRequest);

  @override
  Map<String, dynamic> toMap() {
    if (unixRequest != null) {
      return unixRequest!;
    }
    return grpcRequest!.toProto3Json() as Map<String, dynamic>;
  }
}
