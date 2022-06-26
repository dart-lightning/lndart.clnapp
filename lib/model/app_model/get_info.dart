/// GetInfo wrapper that contains all the information that we need
/// for implementing the the UI feature

class AppGetInfo {
  /// Public Key of the node
  final String nodeId;

  /// Alias of the node
  final String alias;

  AppGetInfo({required this.nodeId, required this.alias});

  factory AppGetInfo.fromJSON(Map<String, dynamic> json) =>
      AppGetInfo(nodeId: json["id"] ?? "Bho", alias: json["alias"] ?? "Bho");
}
