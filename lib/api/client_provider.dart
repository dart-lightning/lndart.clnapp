/// CLN provider is a util class that return the instance of CLN wrapper
/// that works well with the actual platform.
///
/// FIXME: This provided need to take some user choise on what the user want
/// to use.
import 'dart:io' show Platform;
import 'package:clightning_rpc/clightning_rpc.dart';
import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lnlambda/lnlambda.dart';

enum ClientMode {
  unixSocket,
  grpc,
  lnlambda,
}

class ClientProvider {
  static LightningClient getClient(
      {required ClientMode mode, Map<String, dynamic> opts = const {}}) {
    if (kIsWeb) {
      if (mode != ClientMode.lnlambda) {
        /// check if we can run on the web
        throw Exception("The actual client did not support the web");
      }
      return ClientProvider._buildClient(mode: mode, opts: opts);
    }

    if (Platform.isAndroid || Platform.isIOS) {
      throw Exception("The actual client did not support the mobile App");
    }

    if (Platform.isWindows && mode == ClientMode.unixSocket) {
      throw Exception(
          "The unix socket mode is not supported on Windows platform");
    }
    return ClientProvider._buildClient(mode: mode, opts: opts);
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
