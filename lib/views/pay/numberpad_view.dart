import 'dart:convert';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/error_decoder.dart';
import 'package:flutter/material.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:clnapp/model/app_model/withdraw.dart';
import 'package:flutter/services.dart';
import 'package:trash_component/components/global_components.dart';
import 'package:clnapp/utils/app_utils.dart';

class NumberPad extends StatefulWidget {
  final String? invoice;
  final AppProvider provider;
  final String? btcAddress;

  const NumberPad(
      {Key? key, required this.provider, this.invoice, this.btcAddress})
      : super(key: key);

  @override
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String display = '0';

  Future<void> payInvoice(String boltString, int? amountMsat) async {
    try {
      AppPayInvoice response = await widget.provider
          .get<AppApi>()
          .payInvoice(invoice: boltString, msat: amountMsat);
      transactionView(response.payResponse.paymentHash);
    } catch (e) {
      ///FIXME: This could be handled in a better way after this PR gets merged https://github.com/dart-lightning/lndart.clnapp/pull/122
      var jsonString = e.toString().substring(e.toString().indexOf('{'));
      ErrorDecoder decoder = ErrorDecoder.fromJSON(jsonDecode(jsonString));
      GlobalComponent.showAppDialog(
          context: context,
          title: 'Failed to pay the invoice',
          message: decoder.message,
          closeMsg: 'Ok',
          imageProvided: const AssetImage('assets/images/exclamation.png'));
    }
  }

  Future<void> withdraw(String destination, int amount) async {
    try {
      AppWithdraw response = await widget.provider
          .get<AppApi>()
          .withdraw(destination: destination, mSatoshi: amount);
      transactionView(response.tx);
    } catch (e) {
      ///FIXME: This could be handled in a better way after this PR gets merged https://github.com/dart-lightning/lndart.clnapp/pull/122
      var jsonString = e.toString().substring(e.toString().indexOf('{'));
      ErrorDecoder decoder = ErrorDecoder.fromJSON(jsonDecode(jsonString));
      GlobalComponent.showAppDialog(
          context: context,
          title: 'Failed to pay to the given address',
          message: decoder.message,
          closeMsg: 'Ok',
          imageProvided: const AssetImage('assets/images/exclamation.png'));
    }
  }

  void transactionView(String transaction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Payment successful',
            style: Theme.of(context).textTheme.bodyLarge!.apply(
                  fontSizeFactor: 1.6,
                )),
        content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    transaction,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: transaction));
                      showSnackBar('Copied to clipboard', context);
                    },
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                    ))
              ],
            )),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(
          children: [
            const Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                display,
                textScaleFactor: 1.5,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '1'),
                  numberButton(size, '2'),
                  numberButton(size, '3')
                ],
              ),
            ),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '4'),
                  numberButton(size, '5'),
                  numberButton(size, '6')
                ],
              ),
            ),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '7'),
                  numberButton(size, '8'),
                  numberButton(size, '9')
                ],
              ),
            ),
            Expanded(
              child: ButtonBar(
                buttonHeight: 0,
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  numberButton(size, '.'),
                  numberButton(size, '0'),
                  numberButton(
                    size,
                    '',
                    icon: Icons.backspace_outlined,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              child: MainCircleButton(
                  icon: Icons.send_outlined,
                  label: "Pay",
                  onPress: () async {
                    if (widget.invoice != null) {
                      payInvoice(widget.invoice!, int.parse(display));
                    } else {
                      withdraw(widget.btcAddress!, int.parse(display));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget numberButton(Size size, String value, {IconData? icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () {
        if (icon != null) {
          /// Handling the exception
          if (display.length == 1) {
            display = '0';
          } else {
            display = display.substring(0, display.length - 1);
          }
        }

        /// To get only one decimal in the field
        if (display.contains('.')) {
          if (value == '.') {
            return;
          }
        }

        /// Maximum length of 9
        if (display.length > 9) {
          return;
        }
        setState(() {
          display = int.parse(display + value).toString();
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.12,
        width: size.width * 0.15,
        decoration: BoxDecoration(border: Border.all(width: 0.025)),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  size: 35,
                )
              : Text(
                  value,
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
