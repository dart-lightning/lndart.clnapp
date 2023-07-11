import 'dart:io';

import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/bottomsheet.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/decode_invoice.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/pay/numberpad_view.dart';
import 'package:clnapp/views/pay/scanner_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trash_component/components/global_components.dart';

class PayView extends StatefulWidget {
  final AppProvider provider;

  const PayView({Key? key, required this.provider}) : super(key: key);

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  String? boltString;
  final _invoiceController = TextEditingController();
  String? display;
  String? createdTime;
  String? expirationTime;
  String? btcAddress;

  Future<AppPayInvoice> payInvoice(String boltString) async {
    final response =
        await widget.provider.get<AppApi>().payInvoice(invoice: boltString);
    return response;
  }

  Future<AppDecodeInvoice> decodeInvoice(String invoice) async {
    final response = await widget.provider.get<AppApi>().decodeInvoice(invoice);
    return response;
  }

  String getTimeStamp(int timestamp) {
    String date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        .toString()
        .split(' ')
        .first;
    return date;
  }

  void invoiceActions(String boltString) async {
    AppDecodeInvoice invoice = await decodeInvoice(boltString);
    setState(() {
      display = invoice.invoice.amount.toString();
    });
    createdTime = getTimeStamp(invoice.invoice.createdTime);
    expirationTime = getTimeStamp(
        (invoice.invoice.createdTime + invoice.invoice.expirationTime));
    showBottomSheet(invoice: invoice);
  }

  void showBottomSheet({required AppDecodeInvoice invoice}) {
    if (context.mounted) {
      CLNBottomSheet.bottomSheet(
        context: context,
        display: display!,
        provider: widget.provider,
        onPress: (bolt) {
          return payInvoice(bolt);
        },
        boltString: boltString!,
        invoice: invoice.invoice,
        navigate: NumberPad(provider: widget.provider, invoice: boltString!),
        text1: 'Created Time : \n$createdTime',
        text2: 'Expiration Time : \n$expirationTime',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    boltString = '';
    _invoiceController.dispose();
  }

  Widget _buildMainView(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            minLines: 5,
            maxLines: 10,
            controller: _invoiceController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 121, 197),
                  width: 1.0,
                ),
              ),
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.all(30),
              labelText: 'Invoice/ btc address',
              hintText: 'Invoice/ btc address',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MainCircleButton(
              icon: Icons.copy,
              label: "Paste from clipboard",
              width: 200,
              onPress: () async {
                ClipboardData? data = await Clipboard.getData('text/plain');
                setState(() {
                  _invoiceController.text = data!.text!;
                });
                if (data!.text!.startsWith('ln')) {
                  /// This is a lightning invoice
                  boltString = data.text;
                  invoiceActions(boltString!);
                } else if (data.text!.startsWith('tb1')) {
                  /// This is a btc address
                  btcAddress = data.text;
                  if (context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NumberPad(
                              provider: widget.provider,
                              btcAddress: btcAddress,
                            )));
                  }
                } else {
                  /// Throwing error
                  if (context.mounted) {
                    GlobalComponent.showAppDialog(
                        context: context,
                        title: 'Invalid details',
                        message: 'Please check the details you added',
                        closeMsg: 'Ok',
                        imageProvided:
                            const AssetImage('assets/images/exclamation.png'));
                  }
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          !kIsWeb && (Platform.isIOS || Platform.isAndroid)
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const ImageIcon(
                        AssetImage('assets/images/scanner.png')),
                    onPressed: () async {
                      String str =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScannerView(
                                    provider: widget.provider,
                                  )));
                      if (str.startsWith('lntb')) {
                        /// Declare the boltString here
                        boltString = str;
                        invoiceActions(boltString!);
                      } else {
                        /// Declare the btc address here
                        btcAddress = str;
                        if (context.mounted) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NumberPad(
                                    provider: widget.provider,
                                    btcAddress: btcAddress,
                                  )));
                        }
                      }
                      LogManager.getInstance.debug(str);
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: _buildMainView(context),
    );
  }
}
