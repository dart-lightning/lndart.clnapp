import 'package:clnapp/model/app_model/app_utils.dart';

/// GetInfo wrapper that contains all the information that we need
/// for implementing the the UI feature

class AppGetInfo {
  /// Public Key of the node
  final String nodeId;

  /// Alias of the node
  final String alias;

  int totOffChainMsat = 0;

  AppGetInfo({required this.nodeId, required this.alias});

  factory AppGetInfo.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var id = json.withKey("id", snackCase: snackCase)!;
    var alias = json.withKey("alias", snackCase: snackCase)!;
    return AppGetInfo(nodeId: id, alias: alias);
  }
}
