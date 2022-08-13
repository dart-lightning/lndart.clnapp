import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PayView extends StatefulWidget {
  final AppProvider provider;

  const PayView({Key? key, required this.provider}) : super(key: key);
  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  String? boltString;
  int? amountMsat;
  AppPayInvoice? paymentResponse;

  Future<AppPayInvoice> payInvoice(String boltString, int? amountMsat) async {
    try {
      final response = await widget.provider
          .get<AppApi>()
          .payInvoice(invoice: boltString, msat: amountMsat);
      return response;
    } catch (ex) {
      AppPayInvoice error =
          AppPayInvoice(payResponse: {"Error": ex.toString()});
      return error;
    }
  }

  Widget _buildMainView() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            onChanged: (invoiceBolt) {
              boltString = invoiceBolt;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Invoice Bolt11/12',
              hintText: 'Bolt11/12',
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: amountMsat == null ? false : true,
                onChanged: (value) {
                  setState(() {
                    amountMsat = (value == true ? 0 : null);
                  });
                },
              ),
              const Text(
                'Enter milli-satoshi amount?',
                style: TextStyle(fontSize: 17.0),
              ), //Text//SizedBox
            ],
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (amount) {
              amountMsat = int.parse(amount);
            },
            enabled: amountMsat == null ? false : true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(),
              labelText: 'Amount to send in millisatoshi',
              hintText: 'Eg: 100 msats',
            ),
          ),
          MainCircleButton(
              icon: Icons.send_outlined,
              label: "Pay",
              onPress: () {
                if (boltString == null || boltString!.isEmpty) {
                  AppPayInvoice error = AppPayInvoice(payResponse: {
                    "Error": "Error: Bolt11/12 Invoice required"
                  });
                  setState(() {
                    paymentResponse = error;
                  });
                } else {
                  payInvoice(boltString!, amountMsat).then((value) => {
                        setState(() {
                          paymentResponse = value;
                        }),
                      });
                }
              }),
          paymentResponse != null
              ? paymentResponse!.payResponse["Error"] == null
                  ? Text(
                      "Payment Successfully : ${paymentResponse!.payResponse["amountMsat"]["msat"]} msats")
                  : Text("${paymentResponse!.payResponse["Error"]}")
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: _buildMainView(),
    );
  }
}
