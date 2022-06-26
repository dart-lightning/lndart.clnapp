import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/cln/request/cln_request.dart';

class CLNListTransactionRequest extends CLNRequest<ListtransactionsRequest> {
  CLNListTransactionRequest(
      {Map<String, dynamic>? unixRequest, ListtransactionsRequest? grpcRequest})
      : super(unixRequest: unixRequest, grpcRequest: grpcRequest);

  @override
  Map<String, dynamic> toMap() {
    if (unixRequest != null) {
      return unixRequest!;
    }
    return grpcRequest!.writeToJsonMap();
  }
}
