import 'package:clnapp/api/api.dart';
import 'package:clnapp/components/bottomsheet.dart';
import 'package:clnapp/components/buttons.dart';
import 'package:clnapp/model/app_model/decode_invoice.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/pay/numberpad_view.dart';
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
  final _invoiceController = TextEditingController();
  String? display;

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

  void invoiceActions() async {
    AppDecodeInvoice invoice = await decodeInvoice(_invoiceController.text);
    setState(() {
      display = invoice.invoice.amount.toString();
    });
    String createdTime = getTimeStamp(invoice.invoice.createdTime);
    String expirationTime = getTimeStamp(
        (invoice.invoice.createdTime + invoice.invoice.expirationTime));
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

  Widget _buildMainView(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              contentPadding: const EdgeInsets.all(20),
              labelText: 'Invoice',
              hintText: 'invoice',
            ),
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
                boltString = data!.text;
                invoiceActions();
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
      ),
      body: _buildMainView(context),
    );
  }
}
