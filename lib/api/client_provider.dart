/// CLN provider is a util class that return the instance of CLN wrapper
/// that works well with the actual platform.
///
/// FIXME: This provided need to take some user choise on what the user want
/// to use.
import 'dart:io' show Platform;
import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum ClientMode {
  unixSocket,
  grpc,
}

class ClientProvider {
  static LightningClient getClient(
      {required ClientMode mode, Map<String, dynamic> opts = const {}}) {
    if (kIsWeb) {
      /// check if we can run on the web, for now NO
      throw Exception("The actual client did not support the web");
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
        throw Exception("Unix RPC not supported");
      case ClientMode.grpc:
        return GRPCClient(
            rootPath: opts['certificatePath'],
            host: opts['host'],
            port: opts['port']);
    }
  }
}
