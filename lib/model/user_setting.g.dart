// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      clientMode:
          $enumDecodeNullable(_$ClientModeEnumMap, json['clientMode']) ??
              ClientMode.grpc,
      host: json['host'] as String? ?? "localhost",
      path: json['path'] as String? ?? "No path found",
      nodeId: json['nodeId'] as String? ?? "No node id",
      lambdaServer: json['lambdaServer'] as String? ?? "No lambda server",
      rune: json['rune'] as String? ?? "No rune",
    );

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'clientMode': _$ClientModeEnumMap[instance.clientMode]!,
      'host': instance.host,
      'path': instance.path,
      'nodeId': instance.nodeId,
      'lambdaServer': instance.lambdaServer,
      'rune': instance.rune,
    };

const _$ClientModeEnumMap = {
  ClientMode.unixSocket: 'unixSocket',
  ClientMode.grpc: 'grpc',
  ClientMode.lnlambda: 'lnlambda',
};
