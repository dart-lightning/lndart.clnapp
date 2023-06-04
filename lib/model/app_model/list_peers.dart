import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListPeers {
  ListPeers id;

  AppListPeers(this.id);

  factory AppListPeers.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    LogManager.getInstance.debug("RESPONSE HERE : $json");
    var invoice = ListPeers.fromJSON(json, snackCase: snackCase);
    return AppListPeers(invoice);
  }
}

class ListPeers {
  final bool status;

  ListPeers({
    required this.status,
  });

  factory ListPeers.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var status = json.withKey("peers", snackCase: snackCase) as List;
    LogManager.getInstance.debug("This is the status : $status");
    var connected = (status.first as Map<String, dynamic>)
        .withKey("connected", snackCase: snackCase);

    LogManager.getInstance.debug("THIS IS THE ID $connected");

    return ListPeers(
      status: connected,
    );
  }
}
