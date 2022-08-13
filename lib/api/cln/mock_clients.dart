import 'package:cln_common/cln_common.dart';

class GRPCClient extends LightningClient {
  GRPCClient(
      {required String rootPath,
      String? certClientPath,
      String host = 'localhost',
      String authority = 'localhost',
      int port = 8001});

  @override
  Future<T> call<R extends Serializable, T>(
      {required String method,
      required R params,
      T Function(Map p1)? onDecode}) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  void close() {
    // TODO: implement close
  }

  @override
  LightningClient connect(String url) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> simpleCall(String method,
      {Map<String, dynamic> params = const {}}) {
    // TODO: implement simpleCall
    throw UnimplementedError();
  }
}

class RPCClient extends LightningClient {
  @override
  Future<T> call<R extends Serializable, T>(
      {required String method,
      required R params,
      T Function(Map p1)? onDecode}) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  void close() {
    // TODO: implement close
  }

  @override
  LightningClient connect(String url) {
    return this;
  }

  @override
  Future<Map<String, dynamic>> simpleCall(String method,
      {Map<String, dynamic> params = const {}}) {
    // TODO: implement simpleCall
    throw UnimplementedError();
  }
}
