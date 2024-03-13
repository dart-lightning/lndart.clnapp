// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      clientMode: $enumDecodeNullable(_$ClientModeEnumMap, json['clientMode']),
      host: json['host'] as String?,
      path: json['path'] as String?,
      nodeId: json['nodeId'] as String?,
      customLambdaServer: json['customLambdaServer'] as bool?,
      lambdaServer: json['lambdaServer'] as String?,
      rune: json['rune'] as String?,
    );

Map<String, dynamic> _$SettingToJson(Setting instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('clientMode', _$ClientModeEnumMap[instance.clientMode]);
  writeNotNull('host', instance.host);
  writeNotNull('path', instance.path);
  writeNotNull('nodeId', instance.nodeId);
  writeNotNull('customLambdaServer', instance.customLambdaServer);
  writeNotNull('lambdaServer', instance.lambdaServer);
  writeNotNull('rune', instance.rune);
  return val;
}

const _$ClientModeEnumMap = {
  ClientMode.unixSocket: 'unixSocket',
  ClientMode.grpc: 'grpc',
  ClientMode.lnlambda: 'lnlambda',
};
