import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_invoices.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/pay/pay_view.dart';
import 'package:clnapp/views/setting/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:trash_component/components/expandable_card.dart';

class HomeView extends StatefulAppView {
  const HomeView({Key? key, required AppProvider provider})
      : super(key: key, provider: provider);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  late final pages = [
    _buildMainView(context: context),
    SettingView(provider: widget.provider),
  ];

  Widget _buildInfoView(
      {required BuildContext context, required AppGetInfo getInfo}) {
    return Container(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              getInfo.alias,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Available balance",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            "${getInfo.totOffChainMsat} sats",
            style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 3,
                width: 3,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Container(
                height: 3,
                width: 3,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            MainCircleButton(
              icon: Icons.send_outlined,
              label: "Send",
              onPress: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PayView(provider: widget.provider))),
              },
            ),
            MainCircleButton(
                icon: Icons.call_received_outlined,
                label: "Request",
                onPress: () {}),
          ])
        ]));
  }

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

  bool checkListIdentifier({var listTile}) {
    if (listTile.identifier == "invoice") {
      return true;
    }
    return false;
  }

  Widget _buildPaymentListView({required BuildContext context}) {
    return FutureBuilder<List<dynamic>?>(
        future: listPayments(),
        builder: (context, AsyncSnapshot<List<dynamic>?> snapshot) {
          String error = '';
          if (snapshot.hasError) {
            LogManager.getInstance.error("${snapshot.error}");
            LogManager.getInstance.error("${snapshot.stackTrace}");
            error = snapshot.error!.toString();
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
                        context: context, items: snapshot.data!, index: index),
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
        });
  }

  Widget _buildMainView({required BuildContext context}) {
    return FutureBuilder<AppGetInfo>(
        future: widget.provider.get<AppApi>().getInfo(),
        builder: (context, AsyncSnapshot<AppGetInfo> snapshot) {
          String error = '';
          if (snapshot.hasError) {
            /// This error resonates with the user either not having his/her node up
            /// or the file they have chosen can't communicate with the server.
            LogManager.getInstance.error("${snapshot.error}");
            LogManager.getInstance.error("${snapshot.stackTrace}");
            error = snapshot.error!.toString();
          } else if (snapshot.hasData) {
            var getInfo = snapshot.data!;
            return SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(children: <Widget>[
                  ///TODO: Put this in a different file
                  _buildInfoView(context: context, getInfo: getInfo),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.055,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.08,
                          MediaQuery.of(context).size.height * 0.01,
                          0,
                          0),
                      child: const Text(
                        "Last Transaction",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  ///TODO: Put this in a different file.
                  _buildPaymentListView(context: context)
                ]));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/exclamation.png'),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      error,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ]),
            ],
          );
        });
  }

  Widget _buildBottomNavigation() {
    return BottomNavyBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      selectedIndex: _currentIndex,
      showElevation: true,
      containerHeight: 68,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        // FIXME: move this inside an Item view
        BottomNavyBarItem(
          icon: const Icon(Icons.home_filled),
          title: const Text('Home'),
          textAlign: TextAlign.center,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).highlightColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          textAlign: TextAlign.center,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).highlightColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLN App"),
        centerTitle: false,
        primary: true,
        elevation: 0,
        leading: Container(),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
