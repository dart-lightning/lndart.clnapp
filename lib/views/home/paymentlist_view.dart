import 'package:cln_common/cln_common.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:trash_component/components/expandable_card.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/model/app_model/list_invoices.dart';

class PaymentListView extends StatefulWidget {
  final AppProvider provider;

  const PaymentListView({Key? key, required this.provider}) : super(key: key);

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  Future<List<dynamic>?> listPayments() async {
    /// For getting the invoices which are paid by the other nodes
    final invoicesList =
        await widget.provider.get<AppApi>().listInvoices(status: "paid");

    /// For getting invoices which are paid by this nodes
    final paysList = await widget.provider.get<AppApi>().listSendPays();

    List list = [];

    list.addAll(invoicesList.invoice);

    list.addAll(paysList.pays);

    /// FIXME: sort the payments list
    return list;
  }

  String topic(AppInvoice topic) {
    if (topic.bolt11 == null) {
      return "bolt12";
    }
    return "bolt11";
  }

  String value(AppInvoice value) {
    if (value.bolt11 == null) {
      return value.bolt12.toString();
    }
    return value.bolt11.toString();
  }

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
    return items[index].identifier == "invoice"
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(topic: "Description", value: items[index].description),
              _text(topic: topic(items[index]), value: value(items[index])),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(
                  topic: "Created At",
                  value: getTimeStamp(int.parse(items[index].createdAt))),
              _text(topic: "Destination", value: items[index].destination),
              _text(topic: "Label", value: items[index].label),
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

  bool checkListIdentifier({var listTile}) {
    if (listTile.identifier == "invoice") {
      return true;
    }
    return false;
  }

  bool isScreenWidthLarge(double width) {
    if (width > 600) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const red = Color.fromRGBO(255, 0, 57, 1);
    const green = Color.fromRGBO(61, 176, 23, 1);
    double size = MediaQuery.of(context).size.width;
    return FutureBuilder<List<dynamic>?>(
        future: listPayments(),
        builder: (context, AsyncSnapshot<List<dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Center(
                  child: Text('Loading...'),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            LogManager.getInstance.error("${snapshot.error}");
            LogManager.getInstance.error("${snapshot.stackTrace}");
            String error = snapshot.error!.toString();
            return Text(error);
          } else if (snapshot.hasData) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isScreenWidthLarge(size) ? 200 : 0),
                    child: ExpandableCard(
                      expandedAlignment: Alignment.topLeft,
                      expandableChild: _buildSpecificPaymentView(
                          context: context,
                          items: snapshot.data!,
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
                              child: checkListIdentifier(
                                      listTile: snapshot.data![index])
                                  ? const Icon(
                                      Icons.arrow_downward,
                                      color: green,
                                    )
                                  : const Icon(
                                      Icons.arrow_upward,
                                      color: red,
                                    ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: checkListIdentifier(
                                        listTile: snapshot.data![index])
                                    ? Text(
                                        " + ${snapshot.data![index].amount} msats",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: green),
                                      )
                                    : Text(
                                        " - ${snapshot.data![index].amountSent} msats",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: red),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Text('No payments found!');
        });
  }
}
