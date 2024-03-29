import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/cln/request/cln_request.dart';

class CLNListPeersRequest extends CLNRequest<ListpeersRequest> {
  CLNListPeersRequest(
      {Map<String, dynamic>? unixRequest, ListpeersRequest? grpcRequest})
      : super(unixRequest: unixRequest, grpcRequest: grpcRequest);

  @override
  Map<String, dynamic> toMap() {
    if (unixRequest != null) {
      return unixRequest!;
    }
    return grpcRequest!.toProto3Json() as Map<String, dynamic>;
  }
}
