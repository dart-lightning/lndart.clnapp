// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      nickName: json['nickName'] as String? ?? "null",
      clientMode:
          $enumDecodeNullable(_$ClientModeEnumMap, json['clientMode']) ??
              ClientMode.grpc,
      host: json['host'] as String? ?? "localhost",
      path: json['path'] as String? ?? "No path found",
      nodeId: json['nodeId'] as String? ?? "No node id",
      lambdaServer: json['lambdaServer'] as String? ?? "No lambda server",
      rune: json['rune'] as String? ?? "No rune",
    );

Map<String, dynamic> _$SettingToJson(Setting instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('nickName', instance.nickName);
  val['clientMode'] = _$ClientModeEnumMap[instance.clientMode]!;
  val['host'] = instance.host;
  val['path'] = instance.path;
  val['nodeId'] = instance.nodeId;
  val['lambdaServer'] = instance.lambdaServer;
  val['rune'] = instance.rune;
  return val;
}

const _$ClientModeEnumMap = {
  ClientMode.unixSocket: 'unixSocket',
  ClientMode.grpc: 'grpc',
  ClientMode.lnlambda: 'lnlambda',
};
