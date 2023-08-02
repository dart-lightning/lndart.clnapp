import 'package:clnapp/model/app_model/bkpr_listincome.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:trash_component/components/expandable_card.dart';

class PaymentListView extends StatefulWidget {
  final AppProvider provider;
  final AppListIncome incomeList;

  const PaymentListView(
      {Key? key, required this.provider, required this.incomeList})
      : super(key: key);

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  Color red = const Color.fromRGBO(255, 0, 57, 1);
  Color green = const Color.fromRGBO(61, 176, 23, 1);

// FIXME: move this in a util function
  String getTimeStamp(int timestamp) {
    String date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        .toString()
        .split(' ')
        .first;
    return date;
  }

  Widget _buildSpecificPaymentView(
      {required BuildContext context,
      required List<dynamic> items,
      required int index}) {
    if (items[index].identifier == "invoice") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(topic: "Date", value: getTimeStamp(items[index].timeStamp)),
          _text(
              topic: "Description",
              value: items[index].description ?? "No description provided"),
          _text(topic: "Payment Type", value: items[index].paymentType),
          _text(topic: "Account", value: items[index].account),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _text(topic: "Date", value: getTimeStamp(items[index].timeStamp)),
        _text(topic: "Payment Type", value: items[index].paymentType),
        _text(topic: "Account", value: items[index].account),
      ],
    );
  }

  Widget _text({required String topic, required String value}) {
    return RichText(
      text: TextSpan(
          text: "$topic : ",
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 121, 197),
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  color: Color.fromARGB(255, 98, 114, 164), fontSize: 15),
            )
          ]),
    );
  }

  Widget checkListIdentifier({var listTile}) {
    if (listTile.creditMsat == 0) {
      return Text(" - ${listTile.debitMsat} msats",
          overflow: TextOverflow.ellipsis,
          style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: red));
    }
    return Text(
      " + ${listTile.creditMsat} msats",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: green),
    );
  }

  /// Returns the arrow giving more info about the funds
  Widget arrow({var listTile}) {
    if (listTile.creditMsat == 0) {
      return Icon(
        Icons.arrow_upward,
        color: red,
      );
    } else {
      return Icon(
        Icons.arrow_downward,
        color: green,
      );
    }
  }

  bool isScreenWidthLarge(double width) {
    if (width > 600) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.incomeList.incomes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isScreenWidthLarge(size) ? 200 : 0),
            child: ExpandableCard(
              expandedAlignment: Alignment.topLeft,
              expandableChild: _buildSpecificPaymentView(
                  context: context,
                  items: widget.incomeList.incomes,
                  index: index),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.1,
                child: Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: arrow(listTile: widget.incomeList.incomes[index]),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: checkListIdentifier(
                            listTile: widget.incomeList.incomes[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
