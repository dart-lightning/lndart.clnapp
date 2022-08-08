/// CLN provider is a util class that return the instance of CLN wrapper
/// that works well with the actual platform.
///
/// FIXME: This provided need to take some user choise on what the user want
/// to use.
import 'package:clightning_rpc/clightning_rpc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) './cln/mock_clients.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'package:clightning_rpc/clightning_rpc.dart';
import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) './cln/mock_clients.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'package:cln_grpc/cln_grpc.dart';
import 'package:flutter/foundation.dart';
import 'package:lnlambda/lnlambda.dart';

enum ClientMode {
  unixSocket,
  grpc,
  lnlambda,
}

extension ClientModeClass on ClientMode {
  bool withCamelCase() {
    return this == ClientMode.grpc;
  }
}

class ClientProvider {
  static LightningClient getClient(
      {required ClientMode mode, Map<String, dynamic> opts = const {}}) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      // Some android/ios specific code
      throw Exception("The actual client did not support the mobile App");
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      // Some desktop specific code there
      return ClientProvider._buildClient(mode: mode, opts: opts);
    } else {
      // Some web specific code there
      if (mode != ClientMode.lnlambda) {
        /// check if we can run on the web
        throw Exception("The actual client did not support the web");
      }
      return ClientProvider._buildClient(mode: mode, opts: opts);
    }
  }

  static LightningClient _buildClient(
      {required ClientMode mode, Map<String, dynamic> opts = const {}}) {
    switch (mode) {
      case ClientMode.unixSocket:
        return RPCClient().connect(opts["path"]);
      case ClientMode.grpc:
        return GRPCClient(
            rootPath: opts['certificatePath'],
            host: opts['host'],
            port: opts['port']);
      case ClientMode.lnlambda:
        return LNLambdaClient(
            nodeID: opts['node_id'],
            host: opts['host'],
            rune: opts['rune'],
            lambdaServer: opts['lambda_server']);
    }
  }
}
