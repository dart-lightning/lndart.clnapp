import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/request/btcadress.dart';
import 'package:flutter/material.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/views/pay/pay_view.dart';

class InfoView extends StatefulWidget {
  final AppProvider provider;
  final AppGetInfo getinfo;

  const InfoView({Key? key, required this.getinfo, required this.provider})
      : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
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
            "${widget.getinfo.totOffChainMsat} sats",
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
              onPress: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BTCAddress(
                              provider: widget.provider,
                            ))),
              },
            ),
          ])
        ]));
  }
}
