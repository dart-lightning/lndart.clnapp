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
import 'package:trash_component/components/global_components.dart';
import 'package:trash_component/utils/platform_utils.dart';
import 'package:clnapp/utils/app_utils.dart';

class PayView extends StatefulWidget {
  final AppProvider provider;

  const PayView({Key? key, required this.provider}) : super(key: key);

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  String? boltString;
  final _controller = TextEditingController();
  String? display;
  String? createdTime;
  String? expirationTime;
  String? btcAddress;

  Future<void> payInvoice(String boltString) async {
    try {
      await widget.provider.get<AppApi>().payInvoice(invoice: boltString);
      if (context.mounted) {
        GlobalComponent.showAppDialog(
            context: context,
            title: 'Payment Successful',
            message: 'Payment successfully sent',
            closeMsg: 'Ok',
            imageProvided: const AssetImage('assets/images/Checkmark.png'));
      }
    } catch (e) {
      ///FIXME: This could be handled in a better way after this PR gets merged https://github.com/dart-lightning/lndart.clnapp/pull/122
      var jsonString = e.toString().substring(e.toString().indexOf('{'));
      ErrorDecoder decoder = ErrorDecoder.fromJSON(jsonDecode(jsonString));
      GlobalComponent.showAppDialog(
          context: context,
          title: 'Payment failed',
          message: decoder.message,
          closeMsg: 'Ok',
          imageProvided: const AssetImage('assets/images/exclamation.png'));
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
    AppDecodeInvoice invoice = await decodeInvoice(boltString);
    setState(() {
      display = invoice.invoice.amount.toString();
    });
    createdTime = getTimeStamp(invoice.invoice.createdTime);
    expirationTime = getTimeStamp(
        (invoice.invoice.createdTime + invoice.invoice.expirationTime));
    showBottomSheet(invoice: invoice);
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
      if (_controller.text.trim().isNotEmpty) {
        navigateToDesiredPage(_controller.text.trim());
      } else {
        showSnackBar('Please enter a valid value', context);
      }
      return true;
    }
    return false;
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

  void navigateToDesiredPage(String text) {
    if (text.startsWith('ln')) {
      /// This is a lightning invoice
      boltString = text;
      invoiceActions(boltString!);
    } else {
      ///FIXME : This could be handled in a better way by having a library that parse the bitcoin address
      /// Assuming this is a btc address
      btcAddress = text;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NumberPad(
                provider: widget.provider,
                btcAddress: btcAddress,
              )));
    }
  }

  @override
  void dispose() {
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    boltString = '';
    _controller.dispose();
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
            controller: _controller,
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
                if (data!.text!.trim() == '' && context.mounted) {
                  showSnackBar('Nothing to paste', context);
                  return;
                }
                setState(() {
                  _controller.text = data.text!;
                });
                navigateToDesiredPage(data.text!);
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
                      String str =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScannerView(
                                    provider: widget.provider,
                                  )));
                      if (str.trim().startsWith('ln')) {
                        /// Declare the boltString here
                        boltString = str;
                        invoiceActions(boltString!);
                      } else {
                        ///FIXME : This could be handled in a better way by having a library that parse the bitcoin address
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
              : Container()
        ],
      ),
      body: _buildMainView(context),
    );
  }
}
