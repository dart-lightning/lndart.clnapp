class Setting {
  String nickName;
  String connectionType;
  String host;
  String path;

  Setting({this.nickName="null", this.connectionType = "gRPC connection", this.host = "localhost", this.path = "No path found"});
}

List<String> clients = [
  'gRPC connection',
  'Unix connection',
  'Lnlambda connection',
];