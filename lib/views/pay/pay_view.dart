import 'dart:convert';
import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/bottomsheet.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/decode_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/error_decoder.dart';
import 'package:clnapp/views/pay/numberpad_view.dart';
import 'package:clnapp/views/pay/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trash_component/utils/platform_utils.dart';

import 'package:clnapp/utils/error.dart';

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

  Future<void> payInvoice(String boltString) async {
    try {
      await widget.provider.get<AppApi>().payInvoice(invoice: boltString);
      if (context.mounted) {
        PopUp.showPopUp(
            context, 'Payment Successful', 'Payment successfully sent', false);
      }
    } catch (e) {
      /// FIXME: this should be manage in a better way
      var jsonString = e.toString().substring(e.toString().indexOf('{'));
      ErrorDecoder decoder = ErrorDecoder.fromJSON(jsonDecode(jsonString));
      PopUp.showPopUp(context, 'Invalid Rune', decoder.message, true);
    }
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
    late AppDecodeInvoice decodedInvoice;
    try {
      decodedInvoice = await decodeInvoice(boltString);
    } catch (e) {
      var jsonString = e.toString().substring(e.toString().indexOf('{'));
      ErrorDecoder decoder = ErrorDecoder.fromJSON(jsonDecode(jsonString));
      PopUp.showPopUp(
          context, 'Failed to decode invoice', decoder.message, true);
      return;
    }
    setState(() {
      display = decodedInvoice.invoice.amount.toString();
    });
    createdTime = getTimeStamp(decodedInvoice.invoice.createdTime);
    expirationTime = getTimeStamp((decodedInvoice.invoice.createdTime +
        decodedInvoice.invoice.expirationTime));
    showBottomSheet(invoice: decodedInvoice);
  }

  @override
  void initState() {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    super.initState();
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    if (event is KeyUpEvent && key == "Enter") {
      LogManager.getInstance.debug("Found: $key");
      invoiceFunction();
      return true;
    }
    return false;
  }

  void invoiceFunction() {
    boltString = _invoiceController.text.trim();
    if (_invoiceController.text.trim().isNotEmpty) {
      invoiceActions(boltString!);
    }
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
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
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
                if (data == null) {
                  return;
                }
                setState(() {
                  _invoiceController.text = data.text!;
                });
                boltString = data.text;
                invoiceActions(data.text!);
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
          PlatformUtils.isMobile
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const ImageIcon(
                        AssetImage('assets/images/scanner.png')),
                    onPressed: () async {
                      boltString =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScannerView(
                                    provider: widget.provider,
                                  )));
                      LogManager.getInstance.debug("bolt string : $boltString");
                      invoiceActions(boltString!);
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
