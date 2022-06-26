import 'package:cln_common/cln_common.dart';

/// TODO maybe too much abstraction?
abstract class CLNRequest<T> extends Serializable {
  Map<String, dynamic>? unixRequest;
  T? grpcRequest;

  CLNRequest({this.unixRequest, this.grpcRequest});

  @override
  Map<String, dynamic> toJSON() {
    return toMap();
  }

  @override
  U as<U>() {
    if (unixRequest != null) {
      return unixRequest! as U;
    }
    return grpcRequest! as U;
  }

  Map<String, dynamic> toMap();
}
