import 'package:clnapp/api/client_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_setting.g.dart';

List<ClientMode> clients = [
  ClientMode.grpc,
  ClientMode.unixSocket,
  ClientMode.lnlambda,
];

@JsonSerializable(includeIfNull: false)
class Setting {
  ClientMode clientMode;
  String host;
  String path;
  String nodeId;
  String lambdaServer;
  String rune;

  Setting(
      {this.clientMode = ClientMode.grpc,
      this.host = "localhost",
      this.path = "No path found",
      this.nodeId = "No node id",
      this.lambdaServer = "No lambda server",
      this.rune = "No rune"});

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SettingToJson(this);
  }

  Map<String, dynamic> toOpts() {
    switch (clientMode) {
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
            'nodeID': nodeId,
            'host': host,
            'rune': rune,
            'lambdaServer': lambdaServer,
          };
        }
    }
  }

  bool isValid() {
    switch (clientMode) {
      case ClientMode.grpc:
        {
          return host.isNotEmpty && path != "No path found";
        }
      case ClientMode.unixSocket:
        {
          return path != "No path found";
        }
      case ClientMode.lnlambda:
        {
          return nodeId.isNotEmpty &&
              lambdaServer.isNotEmpty &&
              rune.isNotEmpty &&
              host.isNotEmpty;
        }
    }
  }
}
