import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/cln/request/cln_request.dart';

class CLNGetInfoRequest extends CLNRequest {
  CLNGetInfoRequest(
      {Map<String, dynamic>? unixRequest, GetinfoRequest? grpcRequest})
      : super(unixRequest: unixRequest, grpcRequest: grpcRequest);

  @override
  Map<String, dynamic> toMap() {
    if (unixRequest != null) {
      return unixRequest!;
    }
    return grpcRequest!.writeToJsonMap();
  }
}
