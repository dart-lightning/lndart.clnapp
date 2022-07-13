import 'package:cln_common/cln_common.dart';

class AppListChannels {
  List<AppChannels> channels;

  AppListChannels({this.channels = const []});

  factory AppListChannels.fromJSON(Map<String, dynamic> json) {
    var channels = json["channels"] as List;
    if (channels.isNotEmpty) {
      var appChannels =
          channels.map((channel) => AppChannels.fromJSON(channel)).toList();
      return AppListChannels(channels: appChannels);
    } else {
      return AppListChannels();
    }
  }
}

class AppChannels {
  /// Source of the channel
  final String source;

  /// Destination of the channel
  final String destination;

  /// The quantity of Bitcoin in millisatoshi
  final int amount;

  AppChannels(
      {required this.source, required this.destination, required this.amount});

  factory AppChannels.fromJSON(Map<String, dynamic> json) {
    LogManager.getInstance.debug("$json");
    // FIXME: the propriety with in the JSON should follow the convention like the cln docs convention?
    return AppChannels(
        source: json["source"],
        destination: json["destination"],
        amount: int.parse(json["amountMsat"]["msat"].toString()));
  }
}
