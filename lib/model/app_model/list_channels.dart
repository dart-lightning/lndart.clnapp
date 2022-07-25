import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListChannels {
  List<AppChannels> channels;

  AppListChannels({this.channels = const []});

  factory AppListChannels.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var channels =
        witKey(key: "channels", json: json, snackCase: snackCase) as List;
    if (channels.isNotEmpty) {
      var appChannels = channels
          .map((channel) => AppChannels.fromJSON(channel, snackCase: snackCase))
          .toList();
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

  factory AppChannels.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("$json");
    var source = witKey(key: "source", json: json, snackCase: snackCase);
    var destination =
        witKey(key: "destination", json: json, snackCase: snackCase);
    var amount = witKey(key: "amountMsat", json: json, snackCase: snackCase)
        as Map<String, dynamic>;
    return AppChannels(
        source: source,
        destination: destination,
        amount: int.parse(amount["msat"].toString()));
  }
}
