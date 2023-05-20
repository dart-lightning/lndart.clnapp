import 'package:cln_common/cln_common.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:trash_component/components/expandable_card.dart';

import '../../api/api.dart';
import '../../model/app_model/list_invoices.dart';

class PaymentListView extends StatefulWidget {
  final AppProvider provider;
  const PaymentListView({Key? key, required this.provider}) : super(key: key);

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  Future<List<dynamic>?> listPayments() async {
    final invoicesList =
        await widget.provider.get<AppApi>().listInvoices(status: "paid");
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

  Widget _buildSpecificPaymentView(
      {required BuildContext context,
      required List<dynamic> items,
      required int index}) {
    return items[index].identifier == "invoice"
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(topic: "Amount", value: items[index].amount),
              _text(topic: "Description", value: items[index].description),
              _text(topic: topic(items[index]), value: value(items[index])),
              _text(topic: "Status", value: items[index].status),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(topic: "Bolt11", value: items[index].bolt11),
              _text(
                  topic: "Payment Preimage",
                  value: items[index].paymentPreimage),
              _text(topic: "Created At", value: items[index].createdAt),
              _text(topic: "status", value: items[index].status),
              _text(topic: "payment Hash", value: items[index].paymentHash),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.055,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.08,
                MediaQuery.of(context).size.height * 0.01,
                0,
                0),
            child: const Text(
              'Last transaction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        FutureBuilder<List<dynamic>?>(
            future: listPayments(),
            builder: (context, AsyncSnapshot<List<dynamic>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Loading...'),
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
                      return ExpandableCard(
                        expandedAlignment: Alignment.topLeft,
                        expandableChild: _buildSpecificPaymentView(
                            context: context,
                            items: snapshot.data!,
                            index: index),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
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
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.red,
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
                                              color: Colors.green),
                                        )
                                      : Text(
                                          " - ${snapshot.data![index].amountSent}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return const Text('No payments found!');
            })
      ],
    );
  }
}
