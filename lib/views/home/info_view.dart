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
  late String amount;
  List<String> currency = ["MSats", "Sats"];
  String? selectedItem = "MSats";

  @override
  void initState() {
    amount = "${widget.income.balance} msats";
    super.initState();
  }

  Widget dropDownMenu(Size size) {
    return SizedBox(
      width: 200,
      height: 60,
      child: DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(30),
          dropdownColor: Theme.of(context).primaryColor,
          iconSize: 0,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(98, 114, 164, 100),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(width: 3, color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  width: 3, color: Theme.of(context).primaryColorLight),
            ),
            suffixIcon: const ImageIcon(
              AssetImage("assets/images/downbutton.png"),
              size: 24,
            ),
          ),
          value: selectedItem,
          style: Theme.of(context).textTheme.bodySmall,
          items: currency
              .map((item) => DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: item,
                    child: Center(
                        child: Text(
                      item.toUpperCase(),
                    )),
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() {
              selectedItem = value;
            });
            if (value == "MSats") {
              amount = "${widget.income.balance} msats";
            } else {
              amount = "${widget.income.balance ~/ 1000} sats";
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(child: dropDownMenu(size)),
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
                        builder: (context) => RequestView(
                              provider: widget.provider,
                            ))),
              },
            ),
          ])
        ]));
  }
}
