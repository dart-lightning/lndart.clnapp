import 'package:clnapp/model/app_model/bkpr_listincome.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/request/request_view.dart';
import 'package:flutter/material.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/views/pay/pay_view.dart';

class InfoView extends StatefulWidget {
  final AppProvider provider;
  final AppGetInfo getinfo;
  final AppListIncome income;

  const InfoView(
      {Key? key,
      required this.getinfo,
      required this.provider,
      required this.income})
      : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

enum Conversion { sats, msats }

class _InfoViewState extends State<InfoView> {
  bool isSwitched = false;
  Conversion _conversion = Conversion.sats;
  late String amount;

  @override
  void initState() {
    amount = "${widget.income.balance} msats";
    super.initState();
  }

  /// When false return msats and when true return sats.
  Widget toggleSwitch() {
    return Switch(
      activeColor: Colors.green,
      inactiveTrackColor: Colors.blue,
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          _conversion == Conversion.msats
              ? _conversion = Conversion.sats
              : _conversion = Conversion.msats;
          setAmount();
          isSwitched = value;
        });
      },
    );
  }

  void setAmount() {
    if (_conversion == Conversion.msats) {
      amount = "${widget.income.balance / 1000} sats";
    } else {
      amount = "${widget.income.balance} msats";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(
                bottom: 20, top: MediaQuery.of(context).size.height * 0.005),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.getinfo.alias,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          toggleSwitch(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
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
              onPress: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestView(
                              provider: widget.provider,
                            ))),
              },
            ),
          ])
        ]));
  }
}
