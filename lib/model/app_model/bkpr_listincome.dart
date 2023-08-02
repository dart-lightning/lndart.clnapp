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
    for (var income in incomeEvents) {
      LogManager.getInstance.debug("Logging for info ${income.toString()}");
      ListIncome temp = ListIncome.fromJSON(income);
      tempBalance += temp.creditMsat;
      tempBalance -= temp.debitMsat;
      outputList.add(temp);
    }
    outputList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    return AppListIncome(balance: tempBalance, incomes: outputList);
  }
}

class ListIncome {
  final int creditMsat;

  final int debitMsat;

  final String identifier;

  final String? description;

  final int timeStamp;

  final String paymentType;

  final String account;

  ListIncome(
      {required this.creditMsat,
      required this.debitMsat,
      required this.identifier,
      this.description,
      required this.timeStamp,
      required this.paymentType,
      required this.account});

  factory ListIncome.fromJSON(Map<String, dynamic> json,
      {bool snackCase = true}) {
    var creditMsat = json.withKey("credit_msat", snackCase: snackCase);
    var debitMsat = json.withKey("debit_msat", snackCase: snackCase);
    var tag = json.withKey("tag", snackCase: snackCase);
    var timestamp = json.withKey("timestamp", snackCase: snackCase);
    var account = json.withKey("account", snackCase: snackCase);
    if (tag == "invoice") {
      var description = json.withKey("description", snackCase: snackCase);
      var identifier = "invoice";
      var paymentForm = json.withKey("tag");
      return ListIncome(
          creditMsat: creditMsat,
          debitMsat: debitMsat,
          description: description,
          identifier: identifier,
          timeStamp: timestamp,
          paymentType: paymentForm,
          account: account);
    }
    var identifier = "non-invoice";
    var paymentForm = json.withKey("tag");
    return ListIncome(
        creditMsat: creditMsat,
        debitMsat: debitMsat,
        timeStamp: timestamp,
        identifier: identifier,
        paymentType: paymentForm,
        account: account);
  }
}
