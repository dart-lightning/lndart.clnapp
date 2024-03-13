import 'package:clnapp/api/client_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_setting.g.dart';

@JsonSerializable(includeIfNull: false)
class Setting {
  ClientMode? clientMode;
  String? host;
  String? path;
  String? nodeId;
  bool? customLambdaServer;
  String? lambdaServer;
  String? rune;

  Setting(
      {this.clientMode,
      this.host,
      this.path,
      this.nodeId,
      this.customLambdaServer = false,
      this.lambdaServer = "https://lnlambda.lnmetrics.info",
      this.rune}) {
    clientMode = ClientProvider.getClientByDefPlatform().first;
  }

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SettingToJson(this);
  }

  ClientMode getClientOrDefPlatform() {
    return clientMode ?? ClientProvider.getClientByDefPlatform().first;
  }

  Map<String, dynamic> toOpts() {
    switch (clientMode!) {
      case ClientMode.grpc:
        {
          return {
            ///FIXME: the  port need specified by the user
            'certificatePath': path,
            'host': host,
            'port': 8001,
          };
        }
      case ClientMode.unixSocket:
        {
          return {
            "path": "$path/lightning-rpc",
          };
        }
      case ClientMode.lnlambda:
        {
          return {
            'nodeId': nodeId,
            'host': host,
            'rune': rune,
            'customLambdaServer': customLambdaServer,
            'lambdaServer': lambdaServer,
          };
        }
    }
  }

  bool isValid() {
    if (clientMode == null) {
      return false;
    }
    switch (clientMode!) {
      case ClientMode.grpc:
        return host != null && path != null;
      case ClientMode.unixSocket:
        return path != null;
      case ClientMode.lnlambda:
        return nodeId != null &&
            customLambdaServer != null &&
            lambdaServer != null &&
            rune != null &&
            host != null;
    }
  }
}
