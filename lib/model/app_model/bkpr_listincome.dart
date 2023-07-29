import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/app_model/app_utils.dart';

class AppListIncome {
  int balance;
  List<ListIncome> incomes;

  AppListIncome({required this.balance, required this.incomes});

  factory AppListIncome.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    int tempBalance = 0;
    LogManager.getInstance.debug("Response : $json");
    var incomeEvents =
        json.withKey("income_events", snackCase: snackCase) as List;
    List<ListIncome> outputList = [];
    if (incomeEvents.isNotEmpty) {
      for (var income in incomeEvents) {
        ListIncome temp = ListIncome.fromJSON(income);

        /// FIXME : Can we do tempbalance = (2 * tempbalance - debit + credit) / 2
        tempBalance += temp.creditMsat;
        tempBalance -= temp.debitMsat;
        outputList.add(temp);
      }
    }
    return AppListIncome(balance: tempBalance, incomes: outputList);
  }
}

class ListIncome {
  final int creditMsat;

  final int debitMsat;

  final String identifier;

  final String? description;

  final int timeStamp;

  ListIncome({
    required this.creditMsat,
    required this.debitMsat,
    required this.identifier,
    this.description,
    required this.timeStamp,
  });

  factory ListIncome.fromJSON(Map<String, dynamic> json,
      {bool snackCase = false}) {
    var creditMsat = json.withKey("credit_msat", snackCase: true);
    var debitMsat = json.withKey("debit_msat", snackCase: true);
    var tag = json.withKey("tag");
    if (tag == "invoice") {
      var description = json.withKey("description");
      var timestamp = json.withKey("timestamp");
      var identifier = "invoice";
      return ListIncome(
        creditMsat: creditMsat,
        debitMsat: debitMsat,
        description: description,
        identifier: identifier,
        timeStamp: timestamp,
      );
    } else {
      var timestamp = json.withKey("timestamp");
      var identifier = "wallet";
      return ListIncome(
        creditMsat: creditMsat,
        debitMsat: debitMsat,
        timeStamp: timestamp,
        identifier: identifier,
      );
    }
  }
}
