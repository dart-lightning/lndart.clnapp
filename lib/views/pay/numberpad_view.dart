import 'package:cln_common/cln_common.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/error.dart';
import 'package:flutter/material.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:clnapp/model/app_model/withdraw.dart';
import 'package:flutter/services.dart';
import 'package:clnapp/utils/app_utils.dart';
import 'package:trash_component/components/numberpad_widget.dart';

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
    } on LNClientException catch (e) {
      if (mounted) {
        PopUp.showPopUp(context, 'Failed to pay the invoice', e.message, true);
      }
    }
  }

  Future<void> withdraw(String destination, int amount) async {
    try {
      AppWithdraw response = await widget.provider
          .get<AppApi>()
          .withdraw(destination: destination, mSatoshi: amount);
      transactionView(response.txId);
    } on LNClientException catch (e) {
      if (mounted) {
        PopUp.showPopUp(
          context,
          'Failed to pay to the given address',
          e.message,
          true,
        );
      }
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        top: true,
        child: NumberPadBody(
          size: MediaQuery.of(context).size,
          display: display,
          onNumberButtonTap: (value, icon) {
            if (icon != null) {
              if (display.length == 1) {
                display = '0';
              } else {
                display = display.substring(0, display.length - 1);
              }
            }

            if (display.contains('.')) {
              if (value == '.') {
                return;
              }
            }

            if (display.length > 9) {
              return;
            }

            setState(() {
              display = int.parse(display + value).toString();
            });
          },
          onPayButtonPress: () async {
            if (widget.invoice != null) {
              payInvoice(widget.invoice!, int.parse(display));
            } else {
              LogManager.getInstance.debug(display.toString());
              withdraw(widget.btcAddress!, int.parse(display));
            }
          },
          iconData: Icons.send_outlined,
          buttonString: "Pay",
        ),
      ),
    );
  }
}
