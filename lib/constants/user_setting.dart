class Setting {
  String nickName;
  String connectionType;
  String host;
  String path;
  String nodeId;
  String lambdaServer;
  String rune;

  Setting(
      {this.nickName = "null",
      this.connectionType = "gRPC connection",
      this.host = "localhost",
      this.path = "No path found",
      this.nodeId = "No node id",
      this.lambdaServer = "No lambda server",
      this.rune = "No rune"});
}

List<String> clients = [
  'gRPC connection',
  'Unix connection',
  'LNlambda connection',
];
